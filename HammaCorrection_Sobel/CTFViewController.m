//
//  CTFViewController.m
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 11/5/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "CTFViewController.h"
#import "NSImage+Filters.h"

@implementation CTFViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self openImage:[NSImage imageNamed:@"warp_speed"]];
}

- (void)openImage:(NSImage *)image {
    self.imageViewInitial.image = image;
//    CGSize size = [self.imageViewInitial.image size];
//    CGFloat mult = MIN(size.width, size.height) / MAX(size.width, size.height);
//    size = (size.height > size.width) ? CGSizeMake(400 * mult, 400) : CGSizeMake(400, 400 * mult);
//    [self.imageViewInitial.image setSize:size];
}

- (IBAction)onShift:(id)sender {
    self.imageViewFiltered.image = [self.imageViewInitial.image makeShifts];
}

@end
