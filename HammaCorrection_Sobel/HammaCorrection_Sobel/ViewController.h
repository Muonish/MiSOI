//
//  ViewController.h
//  HammaCorrection_Sobel
//
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "PlotDatasource.h"

@interface ViewController : NSViewController

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *graphHostingViewGraphInitial;
@property (nonatomic, strong) IBOutlet CPTGraphHostingView *graphHostingViewGraphFiltered;

@property (nonatomic, strong) PlotDatasource *plotGraphInitial;
@property (nonatomic, strong) PlotDatasource *plotGraphFiltered;

@property (weak) IBOutlet NSImageView *imageViewInitial;
@property (weak) IBOutlet NSImageView *imageViewFiltered;

@property (weak) IBOutlet NSTextField *multC;
@property (weak) IBOutlet NSTextField *multGamma;

@property (weak) IBOutlet NSPopUpButton *medianFilterSize;

@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
@property (weak) IBOutlet NSPopUpButton *clustesNumber;

- (void)openImage:(NSImage *)image;

@end

