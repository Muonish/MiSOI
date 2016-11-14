//
//  HistogramDatasource.m
//  HammaCorrection_Sobel
//


#import "HistogramDatasource.h"

@implementation HistogramDatasource

+ (NSMutableArray *)numbersArrayToPointsArray:(NSMutableArray *)numbers {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (int i = 0; i < numbers.count; i++) {
        [points addObject:[NSValue valueWithPoint:CGPointMake(i, [numbers[i] doubleValue])]];
    }
    return points;
}

+ (NSMutableArray *)histogramDataWithNumbers:(NSMutableArray *)numbers
                           numberOfIntervals:(NSInteger)intervalsNumber {
    NSMutableArray * result = [NSMutableArray new];

    double begin = 0;
    double end = 1;

    double intervalEnds[intervalsNumber];
    int frequencies[intervalsNumber];
    memset(frequencies, 0, intervalsNumber*sizeof(int));

    double intervalSize = (end - begin) / intervalsNumber;
    for (int i = 0; i < intervalsNumber; i++) {
        intervalEnds[i] = begin + intervalSize;
        begin = intervalEnds[i];
    }

    for (NSNumber* number in numbers) {
        for (int i = 0; i < intervalsNumber; i++) {
            if (i == 0) {
                if (number.doubleValue <= intervalEnds[i]) {
                    frequencies[i]++;
                }
            } else {
                if (number.doubleValue <= intervalEnds[i] &&
                    number.doubleValue > intervalEnds[i - 1]) {
                    frequencies[i]++;
                }
            }
        }
    }

    for (int i = 0; i < intervalsNumber; i++) {
        [result addObject:@((double)frequencies[i] / numbers.count * 255/2)];
    }
    
    return result;
}

@end
