//
//  ConnectedDomain.h
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/24/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface ConnectedDomain : NSObject

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSColor * color;
@property (weak, nonatomic) ConnectedDomain * parent;

@property (assign, nonatomic) NSInteger square;
@property (assign, nonatomic) NSInteger perimeter;
@property (assign, nonatomic) CGPoint centerOfMass;
@property (assign, nonatomic) CGFloat density;
@property (assign, nonatomic) CGFloat elongation;
@property (assign, nonatomic) CGFloat orientation;

@end
