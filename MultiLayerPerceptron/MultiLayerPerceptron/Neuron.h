//
//  Neuron.h
//  MultiLayerPerceptron
//
//  Created by Valeryia Breshko on 11/27/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Relation.h"
#import "PatternGroup.h"

@interface Neuron : NSObject

@property (strong, nonatomic) NSMutableArray * inputRelations;
@property (strong, nonatomic) NSMutableArray * outputRelations;
@property (strong, nonatomic) Relation * biasRelation;
@property (assign, nonatomic) CGFloat value;

// for final neuron
@property (strong, nonatomic) PatternGroup * patternGroup;

- (instancetype)initWithValue:(CGFloat)value;
- (void)calculateOutput;
- (void)setBiasRelationWithNeuron:(Neuron *)bias;
- (void)calculateOutput;

@end
