//
//  PatternItem.h
//  MultiLayerPerceptron
//
//  Created by Valeryia Breshko on 11/28/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface PatternItem : NSObject

@property (assign, nonatomic) CGFloat * attributes;

+ (NSUInteger)attributesNumber;

- (void)setupAttributesWithImage:(NSImage *)image;
- (void)setupAttributesWithArray:(NSArray *)numbers;

@end
