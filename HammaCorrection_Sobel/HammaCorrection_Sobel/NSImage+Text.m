//
//  NSImage+Text.m
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/24/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "NSImage+Text.h"

@implementation NSImage (Text)

- (void)drawText:(NSString*)text atPoint:(CGPoint)point {
    NSFont *font = [NSFont systemFontOfSize:14];
    NSDictionary * attributes = @{NSFontAttributeName            : font,
                                  NSForegroundColorAttributeName : [NSColor redColor]};
    [self lockFocus];
    [@"." drawAtPoint:point withAttributes:attributes];
    [text drawAtPoint:CGPointMake(point.x + 5, point.y) withAttributes:attributes];
    [self unlockFocus];
}

@end
