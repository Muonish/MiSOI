//
//  ViewController.m
//  HammaCorrection_Sobel
//
//

#import "ViewController.h"
#import "NSImage+Filters.h"
#import "NSImage+Text.h"
#import "HistogramDatasource.h"
#import "RecursiveDomainsDetector.h"
#import "LoopDomainsDetector.h"
#import "KmeansClassifier.h"
#import "KmedoidsClassifier.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray * domains;
@property (strong, nonatomic) DomainsDetector * domainsDetector;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self openImage:[NSImage imageNamed:@"P0001461"]];
}

- (void)openImage:(NSImage *)image {
    self.imageViewInitial.image = image;
    CGSize size = [self.imageViewInitial.image size];
    CGFloat mult = MIN(size.width, size.height) / MAX(size.width, size.height);
    size = (size.height > size.width) ? CGSizeMake(400 * mult, 400) : CGSizeMake(400, 400 * mult);
    [self.imageViewInitial.image setSize:size];
    [self buildGistogramForInitialImage];
}

- (void)buildGistogramForInitialImage {
    self.plotGraphInitial = [[PlotDatasource alloc] initWithHostingView:self.graphHostingViewGraphInitial andData:nil];

    NSMutableArray * data = [self.imageViewInitial.image brightnessArray];
    NSMutableArray * histogramData = [HistogramDatasource histogramDataWithNumbers:data numberOfIntervals:255];

    self.plotGraphInitial.n = @(255);
    self.plotGraphInitial.yMax = @(2);
    self.plotGraphInitial.yMin = @(0);

    [self.plotGraphInitial addPlotWithIdentifier:@"source"
                                      dataSource:[HistogramDatasource numbersArrayToPointsArray:histogramData]];
    [self.plotGraphInitial initialisePlotWithTitle: @"Brigtness spectrum"];
}

- (void)buildGistogramForFilteredImage {
    self.plotGraphFiltered = [[PlotDatasource alloc] initWithHostingView:self.graphHostingViewGraphFiltered andData:nil];
    NSMutableArray * data = [self.imageViewFiltered.image brightnessArray];
    NSMutableArray * histogramData = [HistogramDatasource histogramDataWithNumbers:data numberOfIntervals:255];

    self.plotGraphFiltered.n = @(255);
    self.plotGraphFiltered.yMax = @(2);
    self.plotGraphFiltered.yMin = @(0);

    [self.plotGraphFiltered addPlotWithIdentifier:@"final"
                                       dataSource:[HistogramDatasource numbersArrayToPointsArray:histogramData]];
    [self.plotGraphFiltered initialisePlotWithTitle: @"Brigtness spectrum"];
}

#pragma mark - Gamma correction & Sobel Operator

- (IBAction)onGammaCorrection:(id)sender {
    CGFloat c = [self.multC doubleValue];
    CGFloat gamma = [self.multGamma doubleValue];
    self.imageViewInitial.image = [self.imageViewInitial.image gammaCorrectionWithC:c gamma:gamma];

    [self buildGistogramForInitialImage];
}

- (IBAction)onSobelOperator:(id)sender {
    self.imageViewFiltered.image = [self.imageViewInitial.image sobelOperatorFilter];
    [self buildGistogramForFilteredImage];
}

#pragma mark - Image negative & Low pass filter

- (IBAction)onNegative:(id)sender {
    self.imageViewFiltered.image = [self.imageViewInitial.image negative];
    [self buildGistogramForFilteredImage];
}

- (IBAction)onLowFilter:(id)sender {
    self.imageViewInitial.image = [self.imageViewInitial.image lowFilter];
    [self buildGistogramForInitialImage];
}

#pragma mark - Median filter & Impulse noise

- (IBAction)onMedianFilter:(id)sender {
    NSInteger size = [self.medianFilterSize.selectedItem.title integerValue];
    self.imageViewInitial.image = [self.imageViewInitial.image medianFilterWithSize:size];
    [self buildGistogramForInitialImage];
}

- (IBAction)onImpulseNoise:(id)sender {
    self.imageViewInitial.image = [self.imageViewInitial.image impulseNoise];
    [self buildGistogramForInitialImage];
}

#pragma mark - Binary preparation

- (IBAction)onBinaryPreperetion:(id)sender {
    self.imageViewFiltered.image = [self.imageViewInitial.image binaryCorrection];

    self.domainsDetector = [[RecursiveDomainsDetector alloc] initWithImage:self.imageViewFiltered.image];

    self.domains = [self.domainsDetector domains];

    self.outputTextView.hidden = NO;
    self.outputTextView.string = @"";

    CGFloat mult = self.imageViewFiltered.image.size.width / self.domainsDetector.width;
    NSInteger index = 1;
    for (ConnectedDomain * domain in self.domains) {
        CGPoint correctedPoint = CGPointMake(domain.centerOfMass.x * mult, domain.centerOfMass.y * mult);
        NSString * indexString = [NSString stringWithFormat:@"%ld", (long)index];
        [self.imageViewFiltered.image drawText:indexString atPoint:correctedPoint];
        self.outputTextView.string = [NSString stringWithFormat:@"%@%ld:\n%@\n",self.outputTextView.string, (long)index, domain];
        index++;
    }
}

#pragma mark - K-means classification

- (IBAction)onClassify:(id)sender {
    NSInteger clustersNumber = [self.clustesNumber.selectedItem.title integerValue];
    KmedoidsClassifier * classifier = [[KmedoidsClassifier alloc] initWithDomains:self.domains
                                                               clustersNumber:clustersNumber];

    NSArray * classifiedDomains = [classifier classifiedDomains];

    self.imageViewFiltered.image = [self.domainsDetector imageWithDomains:classifiedDomains];

}


@end
