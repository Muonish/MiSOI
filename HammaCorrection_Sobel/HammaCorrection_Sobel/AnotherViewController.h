//
//  AnotherViewController.h
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/31/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AnotherViewController : NSViewController

@property (weak) IBOutlet NSImageView *imageViewInitial;
@property (weak) IBOutlet NSImageView *imageViewFiltered;

@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;

@property (weak) IBOutlet NSPopUpButton *clustesNumber;

- (void)openImage:(NSImage *)image;

@end
