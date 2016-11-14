//
//  KmedoidsClassifier.m
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/30/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "KmedoidsClassifier.h"

@implementation KmedoidsClassifier

- (NSArray *)classifiedDomains {
    [self classify];

    while ([self kernelsIsChanged]) {
        [self classify];
    }

    return self.domains;
}

- (void)classify {
    CGFloat minway = CGFLOAT_MAX;
    CGFloat way = 0;
    ConnectedDomain * nearestKernel = 0;
    ConnectedDomain * oldKernel = 0;

    for (ConnectedDomain * domain in self.domains) {
        minway = CGFLOAT_MAX;
        if (domain.parent) {
            oldKernel = domain.parent;
            for (ConnectedDomain * kernel in self.kernels) {
                way = [self wayFromDomain:domain toDomain:kernel];
                if (way < minway) {
                    minway = way;
                    nearestKernel = kernel;
                }
            }
            if (oldKernel != nearestKernel) {
                domain.parent = nearestKernel;
                domain.color =  nearestKernel.color;
            }
        }
    }
}

- (CGFloat)wayFromDomain:(ConnectedDomain *)firstDomain toDomain:(ConnectedDomain *)secondDomain {
    if (firstDomain == secondDomain) {
        return CGFLOAT_MAX;
    }
    CGFloat way = 0;
    way += fabs(secondDomain.square - firstDomain.square);
    way += fabs(secondDomain.perimeter - firstDomain.perimeter);
    way += fabs(secondDomain.density - firstDomain.density) * 3;
    //way += fabs(secondDomain.elongation - firstDomain.elongation);
    return way;
}

- (BOOL)kernelsIsChanged {
    BOOL kernelsIsChanged = NO;
    for (int i = 0; i < self.clustersNumber; i++) {
        ConnectedDomain * oldKernel = self.kernels[i];
        ConnectedDomain * newKernel = self.kernels[i];
        CGFloat minWaySum = [self waySumForDomain:oldKernel];

        for (ConnectedDomain * domain in self.domains) {
            if (domain.parent == oldKernel) {
                CGFloat waySum = [self waySumForDomain:domain];
                if (waySum < minWaySum) {
                    minWaySum = waySum;
                    newKernel = domain;
                }
            }
        }
        if (newKernel != oldKernel) {
            oldKernel.parent = newKernel;
            oldKernel.color =  newKernel.color;
            newKernel.parent = nil;
            self.kernels[i] = newKernel;
            kernelsIsChanged = YES;
        }
    }

    return kernelsIsChanged;
}

- (CGFloat)waySumForDomain:(ConnectedDomain *)currentDomain {
    CGFloat waySum = 0;
    for (ConnectedDomain * domain in self.domains) {
        if (currentDomain != domain) {
            waySum += [self wayFromDomain:currentDomain toDomain:domain];
        }
    }
    return waySum;
}

@end
