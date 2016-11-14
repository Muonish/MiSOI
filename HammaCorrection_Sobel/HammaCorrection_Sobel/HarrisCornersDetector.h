//
//  HarrisCornersDetector.h
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 11/5/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface HarrisCornersDetector : NSObject

@property (strong, nonatomic) NSImage * image;
@property (strong, nonatomic) NSBitmapImageRep * rawImg;

@property (assign, nonatomic) NSInteger * bitmapImg;
@property (assign, nonatomic) NSInteger * labels;

@property (strong, nonatomic) NSMutableIndexSet * differentLabels;

@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger height;

- (instancetype)initWithImage:(NSImage *)image;

@end
