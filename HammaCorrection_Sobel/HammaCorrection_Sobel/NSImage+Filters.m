//
//  NSImage+Filters.m
//  HammaCorrection_Sobel
//
//

#import "NSImage+Filters.h"

@implementation NSImage (Filters)

#pragma mark - Corrections

- (NSImage *)gammaCorrectionWithC:(CGFloat)c gamma:(CGFloat)gamma {
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    NSInteger width = [rawImg pixelsWide];
    NSInteger height = [rawImg pixelsHigh];

    for (NSInteger i = 0; i < width; i++) {
        for (NSInteger j = 0; j < height; j++) {
            NSColor * color = [rawImg colorAtX:i y:j];
            CGFloat bright = color.brightnessComponent;

            CGFloat newBright = c * pow(bright, gamma);

            NSColor *c = [NSColor colorWithCalibratedHue:color.hueComponent
                                              saturation:color.saturationComponent
                                              brightness:newBright
                                                   alpha:color.alphaComponent];

            [rawImg setColor:c atX:i y:j];
        }
    }

    return [[NSImage alloc] initWithCGImage:[rawImg CGImage] size:self.size];
}

- (NSImage *)negative {
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    NSInteger width = [rawImg pixelsWide];
    NSInteger height = [rawImg pixelsHigh];

    for (NSInteger i = 0; i < width; i++) {
        for (NSInteger j = 0; j < height; j++) {
            NSColor * color = [rawImg colorAtX:i y:j];

            NSColor *c = [NSColor colorWithCalibratedRed:1.f - color.redComponent
                                                   green:1.f - color.greenComponent
                                                    blue:1.f - color.blueComponent
                                                   alpha:color.alphaComponent];
            [rawImg setColor:c atX:i y:j];
        }
    }

    return [[NSImage alloc] initWithCGImage:[rawImg CGImage] size:self.size];
}

- (NSImage *)binaryCorrection {
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    NSInteger width = [rawImg pixelsWide];
    NSInteger height = [rawImg pixelsHigh];

    for (NSInteger i = 0; i < width; i++) {
        for (NSInteger j = 0; j < height; j++) {
            NSColor * color = [rawImg colorAtX:i y:j];
            CGFloat value = ([color brightnessComponent] > 0.8f);
            NSColor *newColor = [NSColor colorWithCalibratedRed:value
                                                          green:value
                                                           blue:value
                                                          alpha:1.f];

            [rawImg setColor:newColor atX:i y:j];
        }
    }

    return [[NSImage alloc] initWithCGImage:[rawImg CGImage] size:self.size];
}

- (NSImage *)makeShifts {
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    NSInteger width = [rawImg pixelsWide];
    NSInteger height = [rawImg pixelsHigh];

    NSInteger rowHeight = (NSInteger)(height / 31);

    NSInteger rowNumber = 1;
    for (NSInteger j = rowHeight; j < height; j++) {
        rowNumber = j / rowHeight;
        for (NSInteger i = 0; i < width; i++) {
            NSColor * color = [rawImg colorAtX:i y:j];
            NSInteger newX = i - 8 * rowNumber;
            if (newX > 0) {
                [rawImg setColor:color atX:newX y:j];
            } else {
               // [rawImg setColor:color atX:width + newX y:j];
            }
        }
    }

    NSInteger newHeight = height * 2;
    NSInteger newWidth = width / 2;

    NSBitmapImageRep *leftRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                       pixelsWide:newWidth
                                                                       pixelsHigh:height
                                                                    bitsPerSample:rawImg.bitsPerSample
                                                                  samplesPerPixel:rawImg.samplesPerPixel
                                                                         hasAlpha:rawImg.hasAlpha
                                                                         isPlanar:rawImg.isPlanar
                                                                   colorSpaceName:rawImg.colorSpaceName
                                                                      bytesPerRow:rawImg.bytesPerRow
                                                                     bitsPerPixel:rawImg.bitsPerPixel];
    NSBitmapImageRep *rightRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                         pixelsWide:newWidth
                                                                         pixelsHigh:height
                                                                      bitsPerSample:rawImg.bitsPerSample
                                                                    samplesPerPixel:rawImg.samplesPerPixel
                                                                           hasAlpha:rawImg.hasAlpha
                                                                           isPlanar:rawImg.isPlanar
                                                                     colorSpaceName:rawImg.colorSpaceName
                                                                        bytesPerRow:rawImg.bytesPerRow
                                                                       bitsPerPixel:rawImg.bitsPerPixel];

    for (NSInteger j = 0; j < height; j++) {
        for (NSInteger i = 0; i < width; i++) {
            NSColor * color = [rawImg colorAtX:i y:j];
            if (i > width/2) {
                [rightRep setColor:color atX:i - width/2 y:j];
            } else {
                [leftRep setColor:color atX:i y:j];
            }
        }
    }

    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                         pixelsWide:newWidth
                                                                         pixelsHigh:newHeight
                                                                      bitsPerSample:rawImg.bitsPerSample
                                                                    samplesPerPixel:rawImg.samplesPerPixel
                                                                           hasAlpha:rawImg.hasAlpha
                                                                           isPlanar:rawImg.isPlanar
                                                                     colorSpaceName:rawImg.colorSpaceName
                                                                        bytesPerRow:rawImg.bytesPerRow
                                                                       bitsPerPixel:rawImg.bitsPerPixel];

    rowNumber = 0;
    NSInteger y = 0;
    for (NSInteger j = 0; j < height; j++) {
        if (rowNumber != j / rowHeight) {
            rowNumber = j / rowHeight;
            y += rowHeight;
        }
        for (NSInteger i = 0; i < newWidth; i++) {
            NSColor * color = [leftRep colorAtX:i y:j];
            [newRep setColor:color atX:i y:y];
        }
        y++;
    }

    rowNumber = 0;
    y = rowHeight;
    for (NSInteger j = 0; j < height; j++) {
        if (rowNumber != j / rowHeight) {
            rowNumber = j / rowHeight;
            y += rowHeight;
        }
        for (NSInteger i = 0; i < newWidth; i++) {
            NSColor * color = [rightRep colorAtX:i y:j];
            [newRep setColor:color atX:i - 3 y:y];
        }
        y++;
    }


    return [[NSImage alloc] initWithCGImage:[newRep CGImage] size:CGSizeMake(newWidth, newHeight)];
}

#pragma mark - Filters

- (NSImage *)sobelOperatorFilter {
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    NSInteger width = [rawImg pixelsWide];
    NSInteger height = [rawImg pixelsHigh];

    int gx[3][3] = { { -1,  0,  1 },
        { -2,  0,  2 },
        { -1,  0,  1 } };

    int gy[3][3] = { {  1,  2,  1 },
        {  0,  0,  0 },
        { -1, -2, -1 } };

    int allPixR[width][height];
    int allPixG[width][height];
    int allPixB[width][height];

    int limit = 128 * 128;

    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            NSColor * color = [rawImg colorAtX:i y:j];
            allPixR[i][j] = 255 * color.redComponent;
            allPixG[i][j] = 255 * color.greenComponent;
            allPixB[i][j] = 255 * color.blueComponent;
        }
    }

    int new_rx = 0, new_ry = 0;
    int new_gx = 0, new_gy = 0;
    int new_bx = 0, new_by = 0;
    int rc, gc, bc;
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            new_rx = 0;
            new_ry = 0;
            new_gx = 0;
            new_gy = 0;
            new_bx = 0;
            new_by = 0;
            rc = 0;
            gc = 0;
            bc = 0;

            for (int wi = 0; wi < 3; wi++) {
                for (int hw = 0; hw < 3; hw++) {
                    rc = allPixR[i + hw][j + wi];
                    new_rx += gx[wi][hw] * rc;
                    new_ry += gy[wi][hw] * rc;

                    gc = allPixG[i + hw][j + wi];
                    new_gx += gx[wi][hw] * gc;
                    new_gy += gy[wi][hw] * gc;

                    bc = allPixB[i + hw][j + wi];
                    new_bx += gx[wi][hw] * bc;
                    new_by += gy[wi][hw] * bc;
                }
            }
            NSColor * c;
            if (new_rx * new_rx + new_ry * new_ry > limit ||
                new_gx * new_gx + new_gy * new_gy > limit ||
                new_bx * new_bx + new_by * new_by > limit) {

                c = [NSColor colorWithCalibratedHue:1
                                         saturation:1
                                         brightness:1
                                              alpha:1];

            } else {
                c = [NSColor colorWithCalibratedHue:0
                                         saturation:0
                                         brightness:0
                                              alpha:1];
            }
            [rawImg setColor:c atX:i y:j];
        }
    }
    return [[NSImage alloc] initWithCGImage:[rawImg CGImage] size:self.size];
}

- (NSImage *)lowFilter {
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    NSInteger width = [rawImg pixelsWide];
    NSInteger height = [rawImg pixelsHigh];

    int g[3][3] =  { { 1,  1, 1 },
                     { 1,  1, 1 },
                     { 1,  1, 1 } };

    int allPixR[width][height];
    int allPixG[width][height];
    int allPixB[width][height];

    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            NSColor * color = [rawImg colorAtX:i y:j];
            allPixR[i][j] = 255 * color.redComponent;
            allPixG[i][j] = 255 * color.greenComponent;
            allPixB[i][j] = 255 * color.blueComponent;
        }
    }

    int new_r = 0;
    int new_g = 0;
    int new_b = 0;
    int rc, gc, bc;
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            new_r = 0;
            new_g = 0;
            new_b = 0;
            rc = 0;
            gc = 0;
            bc = 0;

            for (int wi = 0; wi < 3; wi++) {
                for (int hw = 0; hw < 3; hw++) {
                    rc = allPixR[i + hw][j + wi];
                    new_r += g[wi][hw] * rc;

                    gc = allPixG[i + hw][j + wi];
                    new_g += g[wi][hw] * gc;

                    bc = allPixB[i + hw][j + wi];
                    new_b += g[wi][hw] * bc;
                }
            }
            CGFloat nr = new_r / 9;
            CGFloat ng = new_g / 9;
            CGFloat nb = new_b / 9;

            NSColor * color = [rawImg colorAtX:i y:j];
            NSColor *c = [NSColor colorWithCalibratedRed:nr/255
                                                   green:ng/255
                                                    blue:nb/255
                                                   alpha:color.alphaComponent];
            [rawImg setColor:c atX:i y:j];
        }
    }
    return [[NSImage alloc] initWithCGImage:[rawImg CGImage] size:self.size];
}

- (NSImage *)medianFilterWithSize:(NSInteger)size {
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    NSInteger width = [rawImg pixelsWide];
    NSInteger height = [rawImg pixelsHigh];

    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {

            NSMutableArray * windowColors = [NSMutableArray new];
            for (int wi = 0; wi < size; wi++) {
                for (int hw = 0; hw < size; hw++) {
                    NSColor * color = [rawImg colorAtX:i + hw y:j + wi];
                    if (color) {
                        [windowColors addObject:color];
                    }
                }
            }
            NSSortDescriptor * brightnessDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"brightnessComponent" ascending:YES];
            NSArray * sortedColors = [windowColors sortedArrayUsingDescriptors:@[brightnessDescriptor]];

            if ([sortedColors count] > (int)(size/2)) {
                NSColor *c = sortedColors[(int)(size/2)];

                [rawImg setColor:c atX:i y:j];
            }
        }
    }
    return [[NSImage alloc] initWithCGImage:[rawImg CGImage] size:self.size];
}

- (NSImage *)maxminFilterWithSize:(NSInteger)size {
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    NSInteger width = [rawImg pixelsWide];
    NSInteger height = [rawImg pixelsHigh];

    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {

            NSMutableArray * windowColors = [NSMutableArray new];
            for (int wi = 0; wi < size; wi++) {
                for (int hw = 0; hw < size; hw++) {
                    NSColor * color = [rawImg colorAtX:i + hw y:j + wi];
                    if (color) {
                        [windowColors addObject:color];
                    }
                }
            }
            NSSortDescriptor * brightnessDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"brightnessComponent" ascending:YES];
            NSArray * sortedColors = [windowColors sortedArrayUsingDescriptors:@[brightnessDescriptor]];

            if ([sortedColors count] > 0) {
                NSColor *c = sortedColors[0];

                [rawImg setColor:c atX:i y:j];
            }
        }
    }

    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {

            NSMutableArray * windowColors = [NSMutableArray new];
            for (int wi = 0; wi < size; wi++) {
                for (int hw = 0; hw < size; hw++) {
                    NSColor * color = [rawImg colorAtX:i + hw y:j + wi];
                    if (color) {
                        [windowColors addObject:color];
                    }
                }
            }
            NSSortDescriptor * brightnessDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"brightnessComponent" ascending:YES];
            NSArray * sortedColors = [windowColors sortedArrayUsingDescriptors:@[brightnessDescriptor]];

            if ([sortedColors count] > (int)(size - 1)) {
                NSColor *c = sortedColors[(int)(size - 1)];

                [rawImg setColor:c atX:i y:j];
            }
        }
    }
    return [[NSImage alloc] initWithCGImage:[rawImg CGImage] size:self.size];
}



#pragma mark - Noises

- (NSImage *)impulseNoise {
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    NSInteger width = [rawImg pixelsWide];
    NSInteger height = [rawImg pixelsHigh];

    for (NSInteger i = 0; i < width; i++) {
        for (NSInteger j = 0; j < height; j++) {
            NSInteger noiseProbability = arc4random() % 100;

            if (noiseProbability > 98) {
                NSColor *c;
                NSInteger saltProbability = arc4random() % 100;
                if (saltProbability > 50) {
                    c = [NSColor colorWithCalibratedRed:1.f/255.f
                                                  green:1.f/255.f
                                                   blue:1.f/255.f
                                                  alpha:1.f];
                } else {
                    c = [NSColor colorWithCalibratedRed:1.f
                                                  green:1.f
                                                   blue:1.f
                                                  alpha:1.f];

                }
                [rawImg setColor:c atX:i y:j];
            }

        }
    }

    return [[NSImage alloc] initWithCGImage:[rawImg CGImage] size:self.size];

}

#pragma mark - Other

- (NSMutableArray *)brightnessArray {
    NSMutableArray * result = [NSMutableArray new];

    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    NSInteger width = [rawImg pixelsWide];
    NSInteger height = [rawImg pixelsHigh];

    for (NSInteger i = 0; i < width; i++) {
        for (NSInteger j = 0; j < height; j++) {
            NSColor * color = [rawImg colorAtX:i y:j];
            CGFloat bright = color.brightnessComponent;
            [result addObject:@(bright)];
        }
    }

    return result;
}

@end
