//
//  PlotDatasource.h
//  HammaCorrection_Sobel
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@interface PlotDatasource : NSObject <CPTScatterPlotDataSource> {
    CPTGraphHostingView *_hostingView;
    CPTXYGraph *_graph;
    NSMutableDictionary *dictionaryData;
}

@property (nonatomic, strong) CPTGraphHostingView *hostingView;
@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, strong) NSMutableDictionary *dictionaryData;

@property (assign) NSNumber *n;
@property (assign) NSNumber *yMax;
@property (assign) NSNumber *yMin;

//@property (nonatomic, strong) NSMutableArray *graphData;

// Methods to create this object and attach it to it's hosting view.
+(PlotDatasource *)plotWithHostingView:(CPTGraphHostingView *)hostingView;
-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data;

// Specific code that creates the scatter plot.
-(void)initialisePlotWithTitle: (NSString *)title ;

- (void)addPlotWithIdentifier: (NSString *)identifier dataSource: (NSMutableArray *)data;

@end
