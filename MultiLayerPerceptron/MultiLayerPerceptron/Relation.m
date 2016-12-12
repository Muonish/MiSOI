//
//  Relation.m
//  MultiLayerPerceptron
//
//  Created by Valeryia Breshko on 11/27/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "Relation.h"

@implementation Relation

- (instancetype)initWithSender:(Neuron *)sender
                      receiver:(Neuron *)receiver
                        weight:(CGFloat)weight {
    self = [super init];
    if (self) {
        self.sender = sender;
        self.receiver = receiver;
        self.weight = weight;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"value = %f", self.weight];
}

- (void)setDeltaWeight:(CGFloat)deltaWeight {
    self.prevDeltaWeight = self.deltaWeight;
    _deltaWeight = deltaWeight;
}

@end
