//
//  HarrisInterface.m
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 11/20/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#include "harris.h"

#import "NSImage+OpenCV.h"
#import "HarrisInterface.h"
#import "NSImage+Text.h"

using namespace std;
using namespace cv;

//Harris algorithm parameters
// Specifies the sensitivity factor of the Harris algorithm (0 < k < 0.25)
static float k = 0.25;
// Size of the box filter that is applied to the integral images
static int boxFilterSize = 3;
// dimension of the maxima suppression box around a maxima
static int maximaSuppressionDimension = 10;

static bool gauss = true;

//UI parameters
// dimension of the objects showing a maxima in the image
int markDimension = 5;


@implementation HarrisInterface
+ (NSImage*) getMaximaPoints:(NSImage*)img percentage:(float)percentage
{
    Mat m_img = [img CVMat];

    // compute harris
    Harris harris(m_img, k, boxFilterSize, gauss);

    // get vector of points wanted
    const vector<pointData> &resPts = harris.getMaximaPoints(percentage, boxFilterSize, maximaSuppressionDimension);
    // cout << resPts.size() << " Points" << endl;

    Mat _img = Util::MarkInImage(m_img, resPts, markDimension);
    return [[NSImage alloc] initWithCVMat:_img];

//    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[img TIFFRepresentation]];
//    double width = [rawImg pixelsWide];
//    double height = [rawImg pixelsHigh];
//
//    NSLog(@"m_img - cols: %d, rows: %d ; width: %d, height: %d\n", m_img.cols, m_img.rows, m_img.size().width, m_img.size().height);
//    NSLog(@"nsimg - width: %f, height: %f\n", [img size].width, [img size].height);
//    NSLog(@"rawimg - width: %f, height: %f\n", width, height);
//
//    for (const pointData& p : resPts) {
//        [img drawText:@"." atPoint:CGPointMake(p.point.y * m_img.size().width / width, img.size.height - p.point.x)];
//    }
//
//    return img;
}

@end
