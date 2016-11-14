//
//  HarrisCornersDetector.m
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 11/5/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "HarrisCornersDetector.h"

@implementation HarrisCornersDetector

- (instancetype)initWithImage:(NSImage *)image {
    self = [super init];
    if (self) {
        self.image = image;
        self.rawImg = [NSBitmapImageRep imageRepWithData:[self.image TIFFRepresentation]];
        self.width = [self.rawImg pixelsWide];
        self.height = [self.rawImg pixelsHigh];

        CGFloat memSize = self.width * self.height * sizeof(NSInteger);
        self.labels = malloc(memSize);
        self.bitmapImg = malloc(memSize);
        memset(self.labels, 0, memSize);
        memset(self.bitmapImg, 0, memSize);

        for (NSInteger i = 0; i < self.width; i++) {
            for (NSInteger j = 0; j < self.height; j++) {
                NSColor * color = [_rawImg colorAtX:i y:j];
                self.bitmapImg[i * self.height + j] = [color brightnessComponent] > 0.5 ? 1 : 0;
            }
        }

    }
    return self;
}

//- (NSArray *)corners {

//TODO: translate C# hell

//    // 1. Calculate partial differences
//    CGFloat memSize = self.width * self.height * sizeof(NSInteger);
//    NSInteger * diffx = malloc(memSize);
//    NSInteger * diffy = malloc(memSize);
//    NSInteger * diffxy = malloc(memSize);
//
//    {
//        NSInteger * pdx = diffx;
//        NSInteger * pdy = diffy;
//        NSInteger * pdxy = diffxy;
//        //byte* src = (byte*)grayImage.ImageData.ToPointer() + srcStride + 1;
//
//        // Skip first row and first column
//        float* dx = pdx + self.width + 1;
//        float* dy = pdy + self.width + 1;
//        float* dxy = pdxy + self.width + 1;
//
//        // for each line
//        for (int y = 1; y < height - 1; y++)
//        {
//            // for each pixel
//            for (int x = 1; x < width - 1; x++, src++, dx++, dy++, dxy++)
//            {
//                // Convolution with horizontal differentiation kernel mask
//                float h = ((src[-srcStride + 1] + src[+1] + src[srcStride + 1]) -
//                           (src[-srcStride - 1] + src[-1] + src[srcStride - 1])) * 0.166666667f;
//
//                // Convolution vertical differentiation kernel mask
//                float v = ((src[+srcStride - 1] + src[+srcStride] + src[+srcStride + 1]) -
//                           (src[-srcStride - 1] + src[-srcStride] + src[-srcStride + 1])) * 0.166666667f;
//
//                // Store squared differences directly
//                *dx = h * h;
//                *dy = v * v;
//                *dxy = h * v;
//            }
//
//            // Skip last column
//            dx++; dy++; dxy++;
//            src += srcOffset + 1;
//        }
//
//        // Free some resources which wont be needed anymore
//        if (image.PixelFormat != PixelFormat.Format8bppIndexed)
//            grayImage.Dispose();
//    }
//
//
//    // 2. Smooth the diff images
//    if (sigma > 0.0)
//    {
//        float[,] temp = new float[height, width];
//
//        // Convolve with Gaussian kernel
//        convolve(diffx, temp, kernel);
//        convolve(diffy, temp, kernel);
//        convolve(diffxy, temp, kernel);
//    }
//
//
//    // 3. Compute Harris Corner Response Map
//    float[,] map = new float[height, width];
//
//    fixed (float* pdx = diffx, pdy = diffy, pdxy = diffxy, pmap = map)
//    {
//        float* dx = pdx;
//        float* dy = pdy;
//        float* dxy = pdxy;
//        float* H = pmap;
//        float M, A, B, C;
//
//        for (int y = 0; y < height; y++)
//        {
//            for (int x = 0; x < width; x++, dx++, dy++, dxy++, H++)
//            {
//                A = *dx;
//                B = *dy;
//                C = *dxy;
//
//                if (measure == HarrisCornerMeasure.Harris)
//                {
//                    // Original Harris corner measure
//                    M = (A * B - C * C) - (k * ((A + B) * (A + B)));
//                }
//                else
//                {
//                    // Harris-Noble corner measure
//                    M = (A * B - C * C) / (A + B + Accord.Math.Special.SingleEpsilon);
//                }
//
//                if (M > threshold)
//                {
//                    *H = M; // insert value in the map
//                }
//            }
//        }
//    }
//
//
//    // 4. Suppress non-maximum points
//    List<IntPoint> cornersList = new List<IntPoint>();
//
//    // for each row
//    for (int y = r, maxY = height - r; y < maxY; y++)
//    {
//        // for each pixel
//        for (int x = r, maxX = width - r; x < maxX; x++)
//        {
//            float currentValue = map[y, x];
//
//            // for each windows' row
//            for (int i = -r; (currentValue != 0) &amp;&amp; (i <= r); i++)
//            {
//                // for each windows' pixel
//                for (int j = -r; j <= r; j++)
//                {
//                    if (map[y + i, x + j] > currentValue)
//                    {
//                        currentValue = 0;
//                        break;
//                    }
//                }
//            }
//
//            // check if this point is really interesting
//            if (currentValue != 0)
//            {
//                cornersList.Add(new IntPoint(x, y));
//            }
//        }
//    }

    
//    return cornersList;
//}

@end
