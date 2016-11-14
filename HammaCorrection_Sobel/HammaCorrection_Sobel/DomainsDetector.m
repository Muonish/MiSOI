//
//  DomainsDetector.m
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/30/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "DomainsDetector.h"

@implementation DomainsDetector

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

- (void)dealloc {
    free(self.bitmapImg);
    free(self.labels);
}

- (NSArray *)domains {
    // override this method
    return nil;
}

- (NSArray *)filledDomains {
    NSMutableArray * domains = [NSMutableArray new];
    [self.differentLabels enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger xSum = 0;
        NSInteger ySum = 0;
        NSInteger square = 0;
        NSInteger perimeter = 0;
        for (NSInteger x = 0; x < self.width; x++) {
            for (NSInteger y = 0; y < self.height; y++) {
                if (idx == self.labels[x * self.height + y]) {
                    square++;
                    xSum += x;
                    ySum += y;
                    if ((x > 0 && self.labels[(x - 1) * self.height + y] != idx) ||
                        (x < self.width - 1 && self.labels[(x + 1) * self.height + y] != idx) ||
                        (y < self.height - 1 && self.labels[x * self.height + (y + 1)] != idx) ||
                        (y > 0 && self.labels[x * self.height + (y - 1)] != idx)) {
                        perimeter++;
                    }
                }
            }
        }
        ConnectedDomain * domain = [ConnectedDomain new];
        domain.index = idx;
        domain.square = square;
        domain.perimeter = perimeter;
        domain.density = perimeter * perimeter / square;
        domain.centerOfMass = CGPointMake(xSum / square, self.height - ySum / square); // height correction because of mac os coordinate system

        [domains addObject:domain];
    }];

    for (ConnectedDomain * domain in domains) {
        CGFloat m11 = 0;
        CGFloat m02 = 0;
        CGFloat m20 = 0;
        for (NSInteger x = 0; x < self.width; x++) {
            for (NSInteger y = 0; y < self.height; y++) {
                if (domain.index == self.labels[x * self.height + y]) {
                    CGPoint c = domain.centerOfMass;
                    m11 += (x - c.x) * (y - c.y);
                    m02 += (y - c.y) * (y - c.y);
                    m20 += (x - c.x) * (x - c.x);
                }
            }
        }
        domain.elongation = (m20 + m02 + sqrt((m20 - m02) * (m20 - m02) + 4 * m11 * m11)) /
        (m20 + m02 - sqrt((m20 - m02) * (m20 - m02) + 4 * m11 * m11));
        domain.orientation = 1/2 * atan(2 * m11 / m20 - m02) * (M_PI/180);
    }

    return [domains copy];
}

#pragma mark - Build image with colors after classifying

- (NSImage *)imageWithDomains:(NSArray *)domains {
    NSMutableDictionary * dict = [NSMutableDictionary new];
    for (ConnectedDomain * domain in domains) {
        [dict setObject:domain.color forKey:@(domain.index)];
    }

    for (NSInteger i = 0; i < self.width; i++) {
        for (NSInteger j = 0; j < self.height; j++) {
            NSInteger index = self.labels[i * self.height + j];
            if (dict[@(index)]) {
                [self.rawImg setColor:dict[@(index)] atX:i y:j];
            }
        }
    }

    return [[NSImage alloc] initWithCGImage:[self.rawImg CGImage] size:self.image.size];
}


@end
