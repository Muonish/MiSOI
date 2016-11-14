//
//  DomainsDetector.h
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/30/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "ConnectedDomain.h"

@interface DomainsDetector : NSObject

@property (strong, nonatomic) NSImage * image;
@property (strong, nonatomic) NSBitmapImageRep * rawImg;

@property (assign, nonatomic) NSInteger * bitmapImg;
@property (assign, nonatomic) NSInteger * labels;

@property (strong, nonatomic) NSMutableIndexSet * differentLabels;

@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger height;

- (instancetype)initWithImage:(NSImage *)image;
- (NSArray *)filledDomains;

- (NSArray *)domains;

- (NSImage *)imageWithDomains:(NSArray *)domains;

@end
