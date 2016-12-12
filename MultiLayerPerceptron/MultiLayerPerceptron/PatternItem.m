//
//  PatternItem.m
//  MultiLayerPerceptron
//
//  Created by Valeryia Breshko on 11/28/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "PatternItem.h"

static const NSUInteger ATTRIBUTES_NUMBER = 600;

@implementation PatternItem

+ (NSUInteger)attributesNumber {
    return ATTRIBUTES_NUMBER;
}

- (instancetype)initWithImage:(NSImage *)image {
    self = [super init];
    if (self) {
        [self setupAttributesWithImage:image];
    }
    return self;
}

- (void)setupAttributesWithImage:(NSImage *)image {
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    NSInteger width = 20;
    NSInteger height = 30;
    [rawImg setSize:CGSizeMake(width, height)];

    NSInteger memSize = width * height * sizeof(NSInteger);
    self.attributes = (CGFloat *)malloc(memSize);

    for (NSInteger i = 0; i < width; i++) {
        for (NSInteger j = 0; j < height; j++) {
            NSColor * color = [rawImg colorAtX:i y:j];
            self.attributes[i * height + j] = [color brightnessComponent] > 0.5 ? 0 : 1;
        }
    }

    NSString * str = @"";
    for (NSInteger i = 0; i < width; i++) {
        for (NSInteger j = 0; j < height; j++) {
            str = [NSString stringWithFormat:@"%@%1.0f", str, self.attributes[i * height + j]];
        }
        str = [NSString stringWithFormat:@"%@\n", str];
    }

    NSLog(@"\n%@", str);
}

- (void)setupAttributesWithArray:(NSArray *)numbers {
    NSInteger memSize = [numbers count] * sizeof(NSInteger);
    self.attributes = (CGFloat *)malloc(memSize);
    for (int i = 0; i < [numbers count]; i++) {
        self.attributes[i] = [numbers[i] floatValue];
    }
}

- (void)dealloc {
    free(self.attributes);
}

@end
