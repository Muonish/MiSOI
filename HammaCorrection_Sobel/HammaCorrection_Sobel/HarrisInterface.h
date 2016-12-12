//
//  HarrisInterface.h
//  HammaCorrection_Sobel
//
//  Created by Valeryia Breshko on 11/20/16.
//  Copyright © 2016 Valeria Breshko. All rights reserved.
//

@interface HarrisInterface : NSObject

+ (NSImage*) getMaximaPoints:(NSImage*)img percentage:(float)percentage;

@end
