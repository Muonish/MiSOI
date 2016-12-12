//
//  MultilayerPerceptron.m
//  MultiLayerPerceptron
//
//  Created by Valeryia Breshko on 11/27/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "MultilayerPerceptron.h"
#import "Neuron.h"
#import "Relation.h"


static const CGFloat epsilon = 0.00000000001;
static const CGFloat learningRate = 0.9f;
static const CGFloat momentum = 0.7f;

@interface MultilayerPerceptron()

@property (strong, nonatomic) NSMutableArray * enters;
@property (strong, nonatomic) NSMutableArray * hiddens;
@property (strong, nonatomic) NSMutableArray * outers;

@property (strong, nonatomic) Neuron * bias;

@property (strong, nonatomic) NSArray * trainingSet;
@property (assign, nonatomic) NSUInteger classNumber;

@end

@implementation MultilayerPerceptron

#pragma mark - Initialization

- (instancetype)initWithTrainingSet:(NSArray *)trainingSet {
    self = [super init];
    if (self) {
        self.bias = [Neuron new];
        self.trainingSet = trainingSet;
        self.classNumber = [self.trainingSet count];
    }
    return self;
}

- (void)setup {
    self.enters = [NSMutableArray new];;
    self.hiddens = [NSMutableArray new];
    self.outers = [NSMutableArray new];
    [self setupNeurons];
    [self setupRelations];
}

- (void)setupNeurons {
    NSInteger attributesNumber = [PatternItem attributesNumber];

    //initialise enter layer
    for (int i = 0; i < attributesNumber; i++) {
        Neuron * enterNeuron = [[Neuron alloc] initWithValue:0];
        [self.enters addObject:enterNeuron];
    }

    // initialise hidden layer
    NSUInteger hiddensNumber = 30;
    for (int i = 0; i < hiddensNumber; i++) {
        Neuron * hiddenNeuron = [[Neuron alloc] initWithValue:0];
        [hiddenNeuron setBiasRelationWithNeuron:self.bias];
        [self.hiddens addObject:hiddenNeuron];
    }

    // initialize outer layer
    for (int i = 0; i < _classNumber; i++) {
        Neuron * outerNeuron = [[Neuron alloc] initWithValue:0];
        outerNeuron.patternGroup = self.trainingSet[i];
        [outerNeuron setBiasRelationWithNeuron:self.bias];
        [self.outers addObject:outerNeuron];
    }
}

- (void)setupRelations {
    [self setupRelationsForSenders:self.enters receivers:self.hiddens];
    [self setupRelationsForSenders:self.hiddens receivers:self.outers];
}

- (CGFloat)getRandom {
    return (arc4random() % 100) / 100.f * 2 - 1.f; // [-1;1[
}

- (void)setupRelationsForSenders:(NSMutableArray *)senders receivers:(NSMutableArray *)receivers {
    for (Neuron * sender in senders) {
        for (Neuron * receiver in receivers) {
            Relation * relation = [[Relation alloc] initWithSender:sender
                                                          receiver:receiver
                                                            weight:[self getRandom]];
            [sender.outputRelations addObject:relation];
            [receiver.inputRelations addObject:relation];
        }
    }
}

#pragma mark - Styding

- (void)activate {
    for (Neuron * n in self.hiddens) {
        [n calculateOutput];
    }
    for (Neuron * n in self.outers) {
        [n calculateOutput];
    }
}

- (void)applyBackpropagation:(Neuron *)expectedOutput {
    //normalize output
    if (expectedOutput.value > 1) {
        expectedOutput.value = 1 - epsilon;
    } else if (expectedOutput.value < 0) {
        expectedOutput.value = 0 + epsilon;
    }

    // outers
    for (Neuron * n in self.outers) {
        NSMutableArray * inrelations = n.inputRelations;
        for (Relation * rel in inrelations) {
            CGFloat ak = n.value;
            CGFloat ai = rel.sender.value;
            CGFloat desiredOutput = expectedOutput.value == ak ? 1.0 : 0.0;

            CGFloat partialDerivative = -ak * (1 - ak) * ai * (desiredOutput - ak);
            CGFloat deltaWeight = -learningRate * partialDerivative;
            CGFloat newWeight = rel.weight + deltaWeight;
            rel.deltaWeight = deltaWeight;
            rel.weight = newWeight + momentum * rel.prevDeltaWeight;
        }
    }

    // hiddens
    for (Neuron * n in self.hiddens) {
        NSMutableArray * inrelations = n.inputRelations;
        NSMutableArray * outrelations = n.outputRelations;
        for (Relation * rel in inrelations) {
            CGFloat aj = n.value;
            CGFloat ai = rel.sender.value;

            double sumKoutputs = 0;
            int j = 0;
            for (Relation * outR in outrelations) {
                CGFloat wjk = outR.weight;
                CGFloat ak = outR.receiver.value;
                CGFloat desiredOutput = expectedOutput.value == ak ? 1.0 : 0.0;
                j++;
                sumKoutputs += -(desiredOutput - ak) * ak * (1 - ak) * wjk;
            }

            CGFloat partialDerivative = aj * (1 - aj) * ai * sumKoutputs;

            CGFloat deltaWeight = -learningRate * partialDerivative;
            CGFloat newWeight = rel.weight + deltaWeight;
            rel.deltaWeight = deltaWeight;
            rel.weight = newWeight + momentum * rel.prevDeltaWeight;
        }
    }

}

- (Neuron *)getOuter {
    CGFloat maxValue = 0;
    Neuron * answerNeuron;
    for (Neuron * outer in self.outers) {
        if (outer.value > maxValue) {
            maxValue = outer.value;
            answerNeuron = outer;
        }
    }

    return answerNeuron ? answerNeuron : [self.outers firstObject];
}

- (void)study {
    [self setup];

    CGFloat errorSum = 1;

    NSInteger maxIterations = 3000;

    while (maxIterations > 0) {

        errorSum = 0;

        for (PatternGroup * group in self.trainingSet) {
            for (PatternItem * item in group.patterns) {
                [self setupEntersWithAttributes:item.attributes];

                [self activate];

                Neuron * resultNeuron = [self getOuter];

                Neuron * targetNeuron = [self outerNeuronForGroup:group];
                CGFloat error = (![resultNeuron isEqual:targetNeuron]) ? resultNeuron.value - targetNeuron.value : 0;
                errorSum += fabs(error);

                [self applyBackpropagation:targetNeuron];
            }
        }

        maxIterations--;

    }

}

- (Neuron *)outerNeuronForGroup:(PatternGroup *)group {
    for (Neuron * outer in self.outers) {
        if (outer.patternGroup == group) {
            return outer;
        }
    }
    return nil;
}

- (void)setupEntersWithAttributes:(CGFloat *)attributes {
    NSUInteger i = 0;
    for (Neuron * enter in self.enters) {
        enter.value = attributes[i];
        i++;
    }
}

#pragma mark - Recognition

- (PatternGroup *)classifyPatternItem:(PatternItem *)patternItem {
    [self setupEntersWithAttributes:patternItem.attributes];

    [self activate];

    Neuron * resultNeuron = [self getOuter];
    return [resultNeuron patternGroup];
}

- (NSString *)extendedResult {
    NSString * result = @"";

    CGFloat weightSum = 0;
    for (Neuron * outer in self.outers) {
        weightSum += outer.value;
    }

    for (Neuron * outer in self.outers) {
        CGFloat weight = outer.value;
        result = [NSString stringWithFormat:@"%@%@ - %0.1f%%\n", result, outer.patternGroup.name,weight/weightSum * 100.f];
    }
    return result;
}


@end
