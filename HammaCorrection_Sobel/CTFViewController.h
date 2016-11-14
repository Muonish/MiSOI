//
//  CTFViewController.h
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 11/5/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CTFViewController : NSViewController

@property (weak) IBOutlet NSImageView *imageViewInitial;
@property (weak) IBOutlet NSImageView *imageViewFiltered;

@end
