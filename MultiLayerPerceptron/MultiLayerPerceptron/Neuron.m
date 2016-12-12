//
//  Neuron.m
//  MultiLayerPerceptron
//
//  Created by Valeryia Breshko on 11/27/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "Neuron.h"
#import "PatternItem.h"

static const NSInteger bias = -1;

@implementation Neuron

- (instancetype)initWithValue:(CGFloat)value {
    self = [super init];
    if (self) {
        self.value = value;
        self.inputRelations = [NSMutableArray new];
        self.outputRelations = [NSMutableArray new];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"value = %f", self.value];
}

- (void)setBiasRelationWithNeuron:(Neuron *)bias {
    Relation * rel = [[Relation alloc] initWithSender:bias receiver:self weight:0];
    _biasRelation = rel;
    [self.inputRelations addObject:rel];
}

- (void)calculateOutput {
    CGFloat s = 0;
    for (Relation * relation in self.inputRelations) {
        s = s + (relation.sender.value * relation.weight);
    }
    s = s + (self.biasRelation.weight * bias);

    self.value = [self sigmoid:s];
}

- (CGFloat)sigmoid:(CGFloat)x {
    return 1.0 / (1.0 + exp(-x));
}

@end
