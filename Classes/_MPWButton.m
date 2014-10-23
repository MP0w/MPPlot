//
//  _MPWButton.m
//  MPPlotExample
//
//  Created by Alex Manzella on 23/10/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "_MPWButton.h"

@implementation _MPWButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(CGRectInset(self.bounds,  -self.tappableAreaOffset.horizontal, -self.tappableAreaOffset.vertical), point);
}

@end

