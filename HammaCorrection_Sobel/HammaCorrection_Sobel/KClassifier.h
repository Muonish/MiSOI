//
//  KClassifier.h
//  HammaCorrection_Sobel
//


#import <Foundation/Foundation.h>
#import "ConnectedDomain.h"

@interface KClassifier : NSObject

@property (strong, nonatomic) NSArray * domains;
@property (strong, nonatomic) NSMutableArray * kernels;
@property (assign, nonatomic) NSInteger clustersNumber;

- (instancetype)initWithDomains:(NSArray *)domains
                 clustersNumber:(NSInteger)number;

- (NSArray *)classifiedDomains;

@end
