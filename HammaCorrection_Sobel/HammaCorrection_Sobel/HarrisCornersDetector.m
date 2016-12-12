//
//  HarrisCornersDetector.m
//  HammaCorrection_Sobel
//


#import "HarrisCornersDetector.h"
#import "NSImage+Filters.h"
#import "Derivatives.h"
#import "NSImage+Text.h"

@interface HarrisCornersDetector()

@property (strong, nonatomic) NSImage * filteredImage;
@property (assign, nonatomic) NSInteger * harrisResponses;
@property (strong, nonatomic) Derivatives * derivatives;

@end

@implementation HarrisCornersDetector

- (instancetype)initWithImage:(NSImage *)image {
    self = [super init];
    if (self) {
        self.image = image;
        self.filteredImage = [[image grayscaleImage] medianFilterWithSize:3] ;
        self.rawImg = [NSBitmapImageRep imageRepWithData:[self.filteredImage TIFFRepresentation]];
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

    [self computeDerivatives];
    [self applyFiltersToDerivatives];
    [self computeHarrisResponsesWithK:0.25];

    return self;
}

- (NSImage *)imageWithResponses {
    for (NSInteger i = 0; i < self.width; i++) {
        for (NSInteger j = 0; j < self.height; j++) {
            if (self.harrisResponses[i * self.height + j] > 1) {
                NSInteger responce = self.harrisResponses[i * self.height + j];
                [self.image drawText:@"" atPoint:CGPointMake(i, j)];
            }
        }
    }
    return self.image;
}

- (void)computeDerivatives {
    Derivatives * d = [Derivatives new];
    CGFloat memSize = self.width * self.height * sizeof(NSInteger);
    d.Ix = malloc(memSize);
    d.Iy = malloc(memSize);
    d.Ixy = malloc(memSize);
    memset(d.Ix, 0, memSize);
    memset(d.Iy, 0, memSize);
    memset(d.Ixy, 0, memSize);

    for (NSInteger i = 0; i < self.width - 2; i++) {
        for (NSInteger j = 0; j < self.height - 2; j++) {
            d.Ix[i * self.height + j] = self.bitmapImg[i * self.height + j] - self.bitmapImg[(i + 2) * self.height + j];
            d.Iy[i * self.height + j] = - self.bitmapImg[i * self.height + j] + self.bitmapImg[i * self.height + j + 2];
            d.Ixy[i * self.height + j] = d.Ix[i * self.height + j]  * d.Iy[i * self.height + j];

        }
    }

    self.derivatives = d;
}

- (void)applyFiltersToDerivatives {

}

- (void)computeHarrisResponsesWithK:(CGFloat)k {
    CGFloat memSize = self.width * self.height * sizeof(NSInteger);
    self.harrisResponses = malloc(memSize);
    memset(self.harrisResponses, 0, memSize);
    for (NSInteger i = 0; i < self.width; i++) {
        for (NSInteger j = 0; j < self.height; j++) {
            CGFloat a11 = self.derivatives.Ix[i * self.height + j] * self.derivatives.Ix[i * self.height + j];
            CGFloat a12 = self.derivatives.Iy[i * self.height + j] * self.derivatives.Iy[i * self.height + j];

            CGFloat a21 = self.derivatives.Ix[i * self.height + j] * self.derivatives.Iy[i * self.height + j];

            CGFloat a22 = a21;

            CGFloat det = a11 * a22 - a12 * a21;
            CGFloat trace = a11 + a22;

            self.harrisResponses[i * self.height + (self.height - j)] = fabs(det - k * trace * trace) * 5 ; // height correction because of mac os coordinate system
        }
    }

}


@end
