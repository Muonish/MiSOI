//
//  AnotherViewController.m
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/31/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "AnotherViewController.h"
#import "NSImage+Filters.h"
#import "NSImage+Text.h"
#import "HistogramDatasource.h"
#import "RecursiveDomainsDetector.h"
#import "LoopDomainsDetector.h"
#import "KmeansClassifier.h"
#import "KmedoidsClassifier.h"

@interface AnotherViewController ()

@property (strong, nonatomic) NSArray * domains;
@property (strong, nonatomic) DomainsDetector * domainsDetector;

@end

@implementation AnotherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self openImage:[NSImage imageNamed:@"P0001460"]];
}

- (void)openImage:(NSImage *)image {
    self.imageViewInitial.image = image;
    CGSize size = [self.imageViewInitial.image size];
    CGFloat mult = MIN(size.width, size.height) / MAX(size.width, size.height);
    size = (size.height > size.width) ? CGSizeMake(400 * mult, 400) : CGSizeMake(400, 400 * mult);
    [self.imageViewInitial.image setSize:size];
}


- (IBAction)onMedianFilter:(id)sender {
    self.imageViewInitial.image = [self.imageViewInitial.image medianFilterWithSize:3];
}

- (IBAction)onDetectDomains:(id)sender {
    self.imageViewFiltered.image = [self.imageViewInitial.image binaryCorrection];

    self.domainsDetector = [[RecursiveDomainsDetector alloc] initWithImage:self.imageViewFiltered.image];

    self.domains = [self.domainsDetector domains];

    self.outputTextView.string = @"";

    CGFloat mult = self.imageViewFiltered.image.size.width / self.domainsDetector.width;
    NSInteger index = 1;
    for (ConnectedDomain * domain in self.domains) {
        CGPoint correctedPoint = CGPointMake(domain.centerOfMass.x * mult, domain.centerOfMass.y * mult);
        NSString * indexString = [NSString stringWithFormat:@"%ld", (long)index];
        [self.imageViewFiltered.image drawText:indexString atPoint:correctedPoint];
        self.outputTextView.string = [NSString stringWithFormat:@"%@----------- %ld ------------\n%@\n",self.outputTextView.string, (long)index, domain];
        index++;
    }
}

- (IBAction)onClassify:(id)sender {
    NSInteger clustersNumber = [self.clustesNumber.selectedItem.title integerValue];
    KmeansClassifier * classifier = [[KmeansClassifier alloc] initWithDomains:self.domains
                                                                   clustersNumber:clustersNumber];

    NSArray * classifiedDomains = [classifier classifiedDomains];

    self.imageViewFiltered.image = [self.domainsDetector imageWithDomains:classifiedDomains];
}

- (IBAction)onMaxMin:(id)sender {
    self.imageViewInitial.image = [self.imageViewInitial.image maxminFilterWithSize:3];
}

@end
