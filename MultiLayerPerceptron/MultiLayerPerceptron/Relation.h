//
//  Relation.h
//  MultiLayerPerceptron
//
//  Created by Valeryia Breshko on 11/27/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Neuron;

@interface Relation : NSObject

@property (strong, nonatomic) Neuron * sender;
@property (strong, nonatomic) Neuron * receiver;
@property (assign, nonatomic) CGFloat weight;
@property (assign, nonatomic) CGFloat prevDeltaWeight;
@property (assign, nonatomic) CGFloat deltaWeight;

- (instancetype)initWithSender:(Neuron *)sender
                      receiver:(Neuron *)receiver
                        weight:(CGFloat)weight;

@end
