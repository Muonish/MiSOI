//
//  ViewController.m
//  MultiLayerPerceptron
//
//  Created by Valeryia Breshko on 11/27/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

#import "ViewController.h"
#import "MultilayerPerceptron.h"

@interface ViewController()

@property (strong, nonatomic) PatternGroup * patternGroupB;
@property (strong, nonatomic) PatternGroup * patternGroupV;
@property (strong, nonatomic) PatternGroup * patternGroupN;

@property (strong, nonatomic) MultilayerPerceptron * perceptron;

@property (unsafe_unretained) IBOutlet NSTextView *resultTextView;
@property (weak) IBOutlet NSImageView *image1;
@property (weak) IBOutlet NSImageView *imageViewTemplate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.patternGroupB = [PatternGroup new]; self.patternGroupB.name = @"b";
    self.patternGroupV = [PatternGroup new]; self.patternGroupV.name = @"v";
    self.patternGroupN = [PatternGroup new]; self.patternGroupN.name = @"n";

    //NSImage * smallB = [self smallImage:[NSImage imageNamed:@"b"]];
    //self.image1.image = smallB;

    PatternItem * letterB = [PatternItem new];
    [letterB setupAttributesWithImage:[NSImage imageNamed:@"b_20x30"]];
    //[letterB setupAttributesWithArray:@[@0, @0, @1]];
    [self.patternGroupB.patterns addObject:letterB];

    PatternItem * letterV = [PatternItem new];
    [letterV setupAttributesWithImage:[NSImage imageNamed:@"v_20x30"]];
//    [letterV setupAttributesWithArray:@[@0, @1, @0]];
    [self.patternGroupV.patterns addObject:letterV];

    PatternItem * letterN = [PatternItem new];
    [letterN setupAttributesWithImage:[NSImage imageNamed:@"n_20x30"]];
    //[letterN setupAttributesWithArray:@[@1, @0, @0]];
    [self.patternGroupN.patterns addObject:letterN];

    NSArray * trainingSet = @[self.patternGroupB, self.patternGroupV, self.patternGroupN];

    self.perceptron = [[MultilayerPerceptron alloc] initWithTrainingSet:trainingSet];

}

- (NSImage *)smallImage:(NSImage *)image {
    NSInteger size = [PatternItem attributesNumber];
    NSBitmapImageRep * rawImg = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    NSInteger width = (NSInteger)sqrt((double)size);
    [rawImg setSize:CGSizeMake(width, width)];
    return [[NSImage alloc] initWithCGImage:[rawImg CGImage] size:image.size];
}

- (IBAction)recognizeB:(id)sender {
    PatternGroup * pg = [self.perceptron classifyPatternItem:[self.patternGroupB.patterns firstObject]];

    self.resultTextView.string = @"";
    self.resultTextView.string = [NSString stringWithFormat:@"Answer: %@\n %@", pg.name, [self.perceptron extendedResult]];
}

- (IBAction)recognizeV:(id)sender {
    PatternGroup * pg = [self.perceptron classifyPatternItem:[self.patternGroupV.patterns firstObject]];

    self.resultTextView.string = @"";
    self.resultTextView.string = [NSString stringWithFormat:@"Answer: %@\n %@", pg.name, [self.perceptron extendedResult]];
}

- (IBAction)recognizeN:(id)sender {
    PatternGroup * pg = [self.perceptron classifyPatternItem:[self.patternGroupN.patterns firstObject]];

    self.resultTextView.string = @"";
    self.resultTextView.string = [NSString stringWithFormat:@"Answer: %@\n %@", pg.name, [self.perceptron extendedResult]];
}

- (IBAction)onStudy:(id)sender {

    [self.perceptron study];

}

- (IBAction)onSelectAnother:(id)sender {
    NSOpenPanel *openPanel	= [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    NSArray* imageTypes = [NSImage imageTypes];
    [openPanel setAllowedFileTypes:imageTypes];

    [openPanel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL * theDoc = [[openPanel URLs] objectAtIndex:0];
            NSString * path = [theDoc path];

            NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
            if (image == nil) {
                NSLog(@"image nil");
            } else {
                [self openImage:image];
            }
        }

    }];
}

- (void)openImage:(NSImage *)image {
    self.imageViewTemplate.image = image;

    PatternItem * letter = [PatternItem new];
    [letter setupAttributesWithImage:image];

    PatternGroup * pg = [self.perceptron classifyPatternItem:letter];

    self.resultTextView.string = @"";
    self.resultTextView.string = [NSString stringWithFormat:@"Answer: %@\n %@", pg.name, [self.perceptron extendedResult]];
}

@end
