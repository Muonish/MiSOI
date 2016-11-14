//
//  KmeansClassifier.m
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/29/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "KmeansClassifier.h"

@implementation KmeansClassifier

- (NSArray *)classifiedDomains {
    [self classify];

    NSInteger maxIterations = 1000;
    while ([self kernelsIsChanged] && maxIterations > 0) {
        [self classify];
        maxIterations--;
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
        ConnectedDomain * centerOfMass = [self centerOfMassForKernel:oldKernel];
        CGFloat minWay = [self wayFromDomain:centerOfMass toDomain:oldKernel];

        for (ConnectedDomain * domain in self.domains) {
            if (domain.parent == oldKernel) {
                CGFloat way = [self wayFromDomain:centerOfMass toDomain:domain];
                if (way < minWay) {
                    minWay = way;
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

// new center of mass for cluster
- (ConnectedDomain *)centerOfMassForKernel:(ConnectedDomain *)kernel {
    ConnectedDomain * centerOfMass = [ConnectedDomain new];
    NSInteger count = 0;
    for (ConnectedDomain * domain in self.domains) {
        if (domain.parent == kernel) {
            centerOfMass.square += domain.square;
            centerOfMass.perimeter += domain.perimeter;
            centerOfMass.elongation += domain.elongation;
            centerOfMass.density += domain.density;
            count++;
        }
    }

    centerOfMass.square /= count ? count : 1;
    centerOfMass.perimeter /= count ? count : 1;
    centerOfMass.elongation /= count ? count : 1;
    centerOfMass.density /= count ? count : 1;

    return centerOfMass;
}

@end
