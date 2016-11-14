//
//  HistogramDatasource.h
//  HammaCorrection_Sobel
//


#import <Foundation/Foundation.h>

@interface HistogramDatasource : NSObject

+ (NSMutableArray *)numbersArrayToPointsArray:(NSMutableArray *)numbers;
+ (NSMutableArray *)histogramDataWithNumbers:(NSMutableArray *)numbers
                           numberOfIntervals:(NSInteger)intervalsNumber;

@end
