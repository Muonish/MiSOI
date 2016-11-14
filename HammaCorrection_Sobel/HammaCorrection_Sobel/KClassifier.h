//
//  KClassifier.h
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 10/30/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
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
