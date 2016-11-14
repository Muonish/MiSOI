//
//  NSImage+Filters.h
//  HammaCorrection_Sobel
//
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Filters)

// Corrections
- (NSImage *)gammaCorrectionWithC:(CGFloat)c gamma:(CGFloat)gamma;
- (NSImage *)negative;
- (NSImage *)binaryCorrection;

- (NSImage *)makeShifts;

// Filters
- (NSImage *)sobelOperatorFilter;
- (NSImage *)lowFilter;
- (NSImage *)medianFilterWithSize:(NSInteger)size;
- (NSImage *)maxminFilterWithSize:(NSInteger)size;

// Noises
- (NSImage *)impulseNoise;

//Other
- (NSMutableArray *)brightnessArray;

@end
