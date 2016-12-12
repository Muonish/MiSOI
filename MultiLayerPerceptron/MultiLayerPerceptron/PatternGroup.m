//
//  PatternGroup.m
//  MultiLayerPerceptron
//
//  Created by Valeryia Breshko on 11/28/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "PatternGroup.h"

@implementation PatternGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        self.patterns = [NSMutableArray new];
    }
    return self;
}

@end
