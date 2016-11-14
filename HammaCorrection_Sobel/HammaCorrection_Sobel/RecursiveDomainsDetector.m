//
//  RecursiveDomainsDetector.m
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/30/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "RecursiveDomainsDetector.h"

@implementation RecursiveDomainsDetector

- (NSArray *)domains {
    [self connectedDomainsRecursively];
    return [self filledDomains];
}

- (void)connectedDomainsRecursively {
    self.differentLabels = [NSMutableIndexSet new];

    NSInteger label = 0;
    for (NSInteger x = 0; x < self.width; x++) {
        for (NSInteger y = 0; y < self.height; y++) {
            [self fillWithLabel:label++ x:x y:y];
        }
    }
}

- (void)fillWithLabel:(NSInteger)label x:(NSInteger)x y:(NSInteger)y {
    if (self.labels[x * self.height + y] == 0 && self.bitmapImg[x * self.height + y] == 1) {
        self.labels[x * self.height + y] = label;
        if (![self.differentLabels containsIndex:label]) {
            [self.differentLabels addIndex:label];
        }

        if (x > 0) {
            [self fillWithLabel:label x:x - 1 y:y];
        }
        if (x < self.width - 1) {
            [self fillWithLabel:label x:x + 1 y:y];
        }
        if (y > 0) {
            [self fillWithLabel:label x:x y:y - 1];
        }
        if (y < self.height - 1) {
            [self fillWithLabel:label x:x y:y + 1];
        }
    }
}

@end
