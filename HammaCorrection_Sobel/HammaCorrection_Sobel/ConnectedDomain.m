//
//  ConnectedDomain.m
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/24/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "ConnectedDomain.h"

@implementation ConnectedDomain

- (NSString *)description {
    return [NSString stringWithFormat:@"\tsquare = %ld\n\tperimeter = %ld\n\tcenterOfMass = %@\n\tdensity = %0.1f\n\telongation = %0.1f\n\torientation = %0.5f", self.square, self.perimeter, NSStringFromPoint(self.centerOfMass), self.density, self.elongation, self.orientation];

}

@end
