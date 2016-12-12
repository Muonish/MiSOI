//
//  MultilayerPerceptron.h
//  MultiLayerPerceptron
//
//  Created by Valeryia Breshko on 11/27/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatternItem.h"
#import "PatternGroup.h"

@interface MultilayerPerceptron : NSObject

- (instancetype)initWithTrainingSet:(NSArray *)trainingSet;
- (void)study;
- (PatternGroup *)classifyPatternItem:(PatternItem *)patternItem;
- (NSString *)extendedResult;

@end
