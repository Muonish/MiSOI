//
//  PlotDatasource.m
//  HammaCorrection_Sobel
//


#import "PlotDatasource.h"

@implementation PlotDatasource
@synthesize hostingView = _hostingView;
@synthesize graph = _graph;
@synthesize dictionaryData = _dictionaryData;

NSArray* colors;

// Initialise the scatter plot in the provided hosting view with the provided data.
// The data array should contain NSValue objects each representing a CGPoint.
-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data {
    self = [super init];
    if ( self != nil ) {
        self.hostingView = hostingView;
        self.dictionaryData = [[NSMutableDictionary alloc] init];
        self.graph = nil;
    }
    colors = [NSArray arrayWithObjects:[CPTColor blueColor],
              [CPTColor redColor],
              [CPTColor cyanColor],
              [CPTColor magentaColor],
              [CPTColor yellowColor], nil];
    return self;
}

// This does the actual work of creating the plot if we don't already have a graph object.
-(void)initialisePlotWithTitle: (NSString *)title {
    // Start with some simple sanity checks before we kick off
    if ( (self.hostingView == nil) || (self.dictionaryData == nil) ) {
        NSLog(@"PlotDataSource: Cannot initialise plot without hosting view or data.");
        return;
    }

    if ( self.graph != nil ) {
        NSLog(@"PlotDataSource: Graph object already exists.");
        return;
    }

    // Create a graph object which we will use to host just one scatter plot.
    CGRect frame = [self.hostingView bounds];
    self.graph = [[CPTXYGraph alloc] initWithFrame:frame];
    self.graph.title = title;

    // Add some padding to the graph, with more at the bottom for axis labels.
    self.graph.plotAreaFrame.paddingTop = 0.0f;
    self.graph.plotAreaFrame.paddingRight = 0.0f;
    self.graph.plotAreaFrame.paddingBottom = 10.f;
    self.graph.plotAreaFrame.paddingLeft = 30.0f;

    // Tie the graph we've created with the hosting view.
    self.hostingView.hostedGraph = self.graph;

    // If you want to use one of the default themes - apply that here.
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];

    // Create a line style that we will apply to the axis.
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 2.0f;

    // Create a text style that we will use for the axis labels.
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 10;
    textStyle.color = [CPTColor blackColor];

    // Setup some floats that represent the min/max values on our axis.
    float xAxisMin = 0;
    float xAxisMax = [self.n floatValue];
    float yAxisMin = [self.yMin floatValue];
    float yAxisMax = [self.yMax floatValue];

    // Create grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1.0;
    majorGridLineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:0.25];

    // We modify the graph's plot space to setup the axis' min / max values.
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:@(xAxisMin) length:@(xAxisMax - xAxisMin)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:@(yAxisMin) length:@(yAxisMax - yAxisMin)];

    // Modify the graph's axis with a label, line style, etc.
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;

    // axisSet.xAxis.title = @"Data X";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = 30.0f;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = 3.0f;
    axisSet.xAxis.majorIntervalLength = @(xAxisMax / 4);
    axisSet.xAxis.minorTicksPerInterval = 1;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.majorGridLineStyle = majorGridLineStyle;

    // axisSet.yAxis.title = @"Data Y";
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleOffset = 50.0f;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.labelTextStyle = textStyle;
    axisSet.yAxis.labelOffset = 3.0f;
    axisSet.yAxis.majorIntervalLength = @(yAxisMax / 4);
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 0.5f;
    axisSet.yAxis.majorGridLineStyle = majorGridLineStyle;

    // Add a plot to our graph and axis. We give it an identifier so that we
    // could add multiple plots (data lines) to the same graph if necessary.
    int i = 0;
    NSMutableArray *plots = [[NSMutableArray alloc] init];

    for (NSString* key in self.dictionaryData) {
        CPTBarPlot *plot = [[CPTBarPlot alloc] init];
        plot.dataSource = self;
        plot.identifier = key;
        plot.name = key;

        // Create a line style that we will apply to the  data line.
        CPTMutableLineStyle *lineStyleData = [CPTMutableLineStyle lineStyle];
        lineStyleData.lineColor = [colors objectAtIndex: (self.dictionaryData.count - i - 1) % [colors count]];
        lineStyleData.lineWidth = 0.5f;


        plot.lineStyle = lineStyleData;
        [self.graph addPlot:plot];
        [plots addObject:plot];
        i++;
    }
    for (CPTBarPlot *plot in plots) {
        if ([plot.lineStyle.lineColor isEqual:[CPTColor blueColor]]) {
            NSLog(@"%@ - blue\n", plot.identifier);
        } else if ([plot.lineStyle.lineColor isEqual:[CPTColor redColor]]) {
            NSLog(@"%@ - red\n", plot.identifier);
        } else if ([plot.lineStyle.lineColor isEqual:[CPTColor cyanColor]]) {
            NSLog(@"%@ - cyan\n", plot.identifier);
        }
        NSLog(@"%@-%@\n", plot.identifier, plot.lineStyle.lineColor );
    }
    NSLog(@"/n");

    // Add legend
    _graph.legend                 = [CPTLegend legendWithGraph:_graph];
    _graph.legend.fill            = [CPTFill fillWithColor:[CPTColor whiteColor]];
    _graph.legend.textStyle       = textStyle;
    _graph.legend.borderLineStyle = lineStyle;
    _graph.legend.cornerRadius    = 5.0;
    _graph.legend.numberOfRows    = 1;
    _graph.legendAnchor           = CPTRectAnchorBottom;
    _graph.legendDisplacement     = CGPointMake( 0.0, 10 * CPTFloat(4.0) );

}

- (void)addPlotWithIdentifier: (NSString *)identifier dataSource: (NSMutableArray *)data{
    [self.dictionaryData setObject:data forKey:identifier];
}

// Delegate method that returns the number of points on the plot
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    for (NSString *key in self.dictionaryData) {
        if ([plot.identifier isEqual:key]) {
            return [[self.dictionaryData objectForKey:key] count];
        }
    }
    return 0;
}

// Delegate method that returns a single X or Y value for a given plot.
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    for (NSString *key in self.dictionaryData) {
        if ([plot.identifier isEqual:key]) {
            NSValue *value = [[self.dictionaryData objectForKey:key] objectAtIndex:index];
            CGPoint point = [value pointValue];

            // FieldEnum determines if we return an X or Y value.
            if ( fieldEnum == CPTScatterPlotFieldX ) {
                return [NSNumber numberWithFloat:point.x];
            } else {	// Y-Axis
                return [NSNumber numberWithFloat:point.y];
            }
        }
    }
    
    return [NSNumber numberWithFloat:0];
}


@end
