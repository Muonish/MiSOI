//
//  AnotherViewController.h
//  HammaCorrection_Sobel
//


#import <Cocoa/Cocoa.h>

@interface AnotherViewController : NSViewController

@property (weak) IBOutlet NSImageView *imageViewInitial;
@property (weak) IBOutlet NSImageView *imageViewFiltered;

@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;

@property (weak) IBOutlet NSPopUpButton *clustesNumber;

- (void)openImage:(NSImage *)image;

@end
