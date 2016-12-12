//
//  KClassifier.m
//  HammaCorrection_Sobel
//


#import "KClassifier.h"

@implementation KClassifier

- (instancetype)initWithDomains:(NSArray *)domains
                 clustersNumber:(NSInteger)number {
    self = [super init];
    if (self) {
        if (number > 0 && [domains count] >= number) {
            self.domains = domains;
            self.clustersNumber = number;
            self.kernels = [NSMutableArray new];

            for (int i = 0; i < number; i++) {
                ConnectedDomain * domain = self.domains[i];
                domain.color = [NSColor colorWithCalibratedRed:(arc4random() % 255) / 255.f
                                                         green:(arc4random() % 255) / 255.f
                                                          blue:(arc4random() % 255) / 255.f
                                                         alpha:1.f];
                domain.parent = nil;
                [self.kernels addObject:self.domains[i]];
            }

            for (ConnectedDomain * domain  in self.domains) {
                if (!domain.color) {
                    domain.parent = self.kernels[0];
                    domain.color = domain.parent.color;
                }
            }
        } else {
            self = nil;
        }
    }
    return self;
}

- (NSArray *)classifiedDomains {
    // override this method
    return nil;
}

@end
