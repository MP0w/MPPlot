//
//  MPPlot.m
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPPlot.h"
#import "MPGraphView.h"

@implementation MPPlot


- (id)init
{
    self = [super init];
    if (self) {
        NSAssert(![self isMemberOfClass:[MPPlot class]], @"You shouldn't init MPPlot directly, use the class method plotWithType:frame:");
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(![self isMemberOfClass:[MPPlot class]], @"You shouldn't init MPPlot directly, use the class method plotWithType:frame:");
    }
    return self;
}


+ (id)plotWithType:(MPPlotType)type frame:(CGRect)frame{
 
    
    switch (type) {
        case MPPlotTypeGraph:
            return [[MPGraphView alloc] initWithFrame:frame];
            break;
            
        default:
            break;
    }
    
    
    return nil;
}

#pragma mark Common











- (NSMutableArray *)pointsForArray:(NSArray *)dict{
    
    CGFloat min,max,avg;
    
    min=max=[[dict firstObject] floatValue];
    
    
    for (NSInteger i=0; i<dict.count; i++) {
        
        CGFloat val=[[dict objectAtIndex:i] floatValue];
        
        if (val>max) {
            max=val;
        }
        
        if (val<min) {
            min=val;
        }
        
        avg+=val;
    }
    
    avg/=dict.count;
    
    
    NSMutableArray *pointsArray=[[NSMutableArray alloc] init];
    
    if(max!=min){
        for (NSString *p in dict) {
            
            CGFloat val=[p floatValue];
            
            val=((val-min)/(max-min));
            
            [pointsArray addObject:@(val)];
        }
        
    }else [pointsArray addObject:@(1)];
    
    return pointsArray;
}



#pragma mark setters



- (void)setValues:(NSArray *)values{
    
    if (values) {
        
        _values=[values copy];
        
        points=[self pointsForArray:_values];
        
        
        [self setNeedsDisplay];
    }
    
}



- (void)setAlgorithm:(GraphPointsAlgorithm)customAlgorithm numberOfPoints:(NSUInteger)numberOfPoints{
    
    _numberOfPoints=numberOfPoints;
    _customAlgorithm=customAlgorithm;
    
    NSMutableArray* values=[[NSMutableArray alloc] init];
    
    for (NSUInteger i=0; i<numberOfPoints; i++) {
        [values addObject:@(customAlgorithm(i))];
    }
    
    self.values=values;
    
    [self setNeedsDisplay];
}




#pragma mark Getters

- (NSNumberFormatter *)detailLabelFormatter{
    
    if (!_detailLabelFormatter) {
        _detailLabelFormatter=[[NSNumberFormatter alloc] init];
        _detailLabelFormatter.locale=[NSLocale currentLocale];
        _detailLabelFormatter.numberStyle=NSNumberFormatterDecimalStyle;
    }
    
    return  _detailLabelFormatter;
}

- (UIColor *)graphColor{
    
    return _graphColor ? _graphColor : [UIColor blueColor];
    
}


- (UIColor *)detailBackgroundColor{
    
    return _detailBackgroundColor ? _detailBackgroundColor : [UIColor whiteColor];
    
}



- (CGFloat)animationDuration{
    return _animationDuration>0.0 ? _animationDuration : ANIMATIONDURATION;
}


#pragma mark Internal

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view=[super hitTest:point withEvent:event];
    
    if (view==self && label.superview) {
        [UIView animateWithDuration:.15 animations:^{
            label.transform=CGAffineTransformMakeScale(0, 0);
        }completion:^(BOOL finished) {
            [label removeFromSuperview]; label=nil;
        }];
    }
    
    return view;
}



- (void)animate{
    
}



@end




@implementation MPButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    return CGRectContainsPoint(CGRectInset(self.bounds, -25, -25), point);
    
}

@end
