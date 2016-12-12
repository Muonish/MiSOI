//
//  HarrisCornersDetector.h
//  HammaCorrection_Sobel
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

- (NSImage *)imageWithResponses;

@end
