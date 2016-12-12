//
//  LoopDomainsDetector.m
//  HammaCorrection_Sobel
//


#import "LoopDomainsDetector.h"

@interface LoopDomainsDetector()

@property (strong, nonatomic) NSMutableArray * equivalentLabelsSets;

@end

@implementation LoopDomainsDetector

- (NSArray *)domains {
    [self connectedDomains];
    return [self filledDomains];
}

- (void)connectedDomains {
    self.differentLabels = [NSMutableIndexSet new];
    self.equivalentLabelsSets = [NSMutableArray new];

    [self fillLabels];
    [self uniteEquivalentDomains];
}

//  +---+---+---+
//  |   | c |   |
//  +---+---+---+
//  | b | a |   |
//  +---+---+---+
//  |   |   |   |
//  +---+---+---+
- (void)fillLabels {
    NSInteger label = 0;
    for (NSInteger x = 0; x < self.width; x++) {
        for (NSInteger y = 0; y < self.height; y++) {
            NSInteger b = (x > 0) ? self.labels[(x - 1) * self.height + y] : 0;
            NSInteger c = (y > 0) ? self.labels[x * self.height + (y - 1)] : 0;
            if (self.bitmapImg[x * self.height + y]) { // if a == 1
                if (!b && !c) {
                    label++;
                    self.labels[x * self.height + y] = label;
                    [self.equivalentLabelsSets addObject:[NSMutableIndexSet indexSetWithIndex:label]];
                } else if ((b && !c) || (c && !b)) { // xor
                    self.labels[x * self.height + y] = b ? b : c;
                } else if (b && c) {
                    self.labels[x * self.height + y] = b;
                    if (b != c) {
                        [self saveEquivalencyOfL1:b andL2:c];
                    }
                }
            }
        }
    }
}

- (void)saveEquivalencyOfL1:(NSInteger)l1 andL2:(NSInteger)l2 {
    BOOL contains = NO;
    for (NSMutableIndexSet * indexSet in self.equivalentLabelsSets) {
        if ([indexSet containsIndex:l1] && ![indexSet containsIndex:l2]) {
            [indexSet addIndex:l2];
        } else if ([indexSet containsIndex:l2] && ![indexSet containsIndex:l1]) {
            [indexSet addIndex:l1];
        }
        contains = ([indexSet containsIndex:l1] || [indexSet containsIndex:l2]);
    }
    if (!contains) {
        NSMutableIndexSet * indexSet = [NSMutableIndexSet new];
        [indexSet addIndex:l1];
        [indexSet addIndex:l2];
        [self.equivalentLabelsSets addObject:indexSet];
    }
}

- (void)uniteEquivalentDomains {
    for (NSInteger x = 0; x < self.width; x++) {
        for (NSInteger y = 0; y < self.height; y++) {
            NSInteger label = self.labels[x * self.height + y];
            if (label) {
                label = [self getSingleLabelForLabel:label];
                if (![self.differentLabels containsIndex:label]) {
                    [self.differentLabels addIndex:label];
                }
                self.labels[x * self.height + y] = label;
            }
        }
    }
}

- (NSInteger)getSingleLabelForLabel:(NSInteger)label {
    for (NSMutableIndexSet * indexSet in self.equivalentLabelsSets) {
        if ([indexSet containsIndex:label]) {
            return [indexSet firstIndex];
        }
    }
    return 0;
}

@end
