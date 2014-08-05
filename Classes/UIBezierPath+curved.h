//
//  UIBezierPath+curved.h
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (curved)


- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity;

@end
