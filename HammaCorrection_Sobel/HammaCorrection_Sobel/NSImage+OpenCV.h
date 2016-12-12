//
//  NSImage+OpenCV.h
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 11/20/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#include <opencv2/opencv.hpp>

#import <Cocoa/Cocoa.h>

@interface NSImage (OpenCV)

+(NSImage*)imageWithCVMat:(const cv::Mat&)cvMat;
-(id)initWithCVMat:(const cv::Mat&)cvMat;

@property(nonatomic, readonly) cv::Mat CVMat;
@property(nonatomic, readonly) cv::Mat CVGrayscaleMat;

@end
