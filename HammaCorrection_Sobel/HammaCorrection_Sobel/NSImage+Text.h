//
//  NSImage+Text.h
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/24/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Text)

- (void)drawText:(NSString*)text atPoint:(CGPoint)point;

@end
