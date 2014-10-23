//
//  _MPWButton.m
//  MPPlotExample
//
//  Created by Alex Manzella on 23/10/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "_MPWButton.h"

@implementation _MPWButton

+ (id)buttonWithType:(UIButtonType)buttonType tappableAreaOffset:(UIOffset)tappableAreaOffset
{
    _MPWButton *button = [super buttonWithType:buttonType];
    button.tappableAreaOffset=tappableAreaOffset;
    return button;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(CGRectInset(self.bounds,  -_tappableAreaOffset.horizontal, -_tappableAreaOffset.vertical), point);
}

@end

