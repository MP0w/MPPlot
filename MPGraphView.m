//
//  MPGraphView.m
//
//
//  Created by Alex Manzella on 18/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPGraphView.h"

// Based on code from Erica Sadun

void getPointsFromBezier(void *info, const CGPathElement *element);
NSArray *pointsFromBezierPath(UIBezierPath *bpath);


#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]
#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

@implementation UIBezierPath (Smoothing)

// Get points from Bezier Curve
void getPointsFromBezier(void *info, const CGPathElement *element)
{
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    // Retrieve the path element type and its points
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    // Add the points if they're available (per type)
    if (type != kCGPathElementCloseSubpath)
    {
        [bezierPoints addObject:VALUE(0)];
        if ((type != kCGPathElementAddLineToPoint) &&
            (type != kCGPathElementMoveToPoint))
            [bezierPoints addObject:VALUE(1)];
    }
    if (type == kCGPathElementAddCurveToPoint)
        [bezierPoints addObject:VALUE(2)];
}

NSArray *pointsFromBezierPath(UIBezierPath *bpath)
{
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(bpath.CGPath, (__bridge void *)points, getPointsFromBezier);
    return points;
}

- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity;
{
    NSMutableArray *points = [pointsFromBezierPath(self) mutableCopy];
    
    if (points.count < 4) return [self copy];
    
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    
    UIBezierPath *smoothedPath = [self copy];
    [smoothedPath removeAllPoints];
    
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSUInteger index = 1; index < points.count - 2; index++)
    {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++)
        {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    return smoothedPath;
}


@end

@interface MPButton : UIButton

@end

@implementation MPButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    return CGRectContainsPoint(CGRectInset(self.bounds, -25, -25), point);
    
}

@end

@implementation MPGraphView



+ (Class)layerClass{
    return [CAShapeLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        currentTag=-1;
        
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    if (self.values.count && !self.waitToUpdate) {
        
        [label removeFromSuperview]; label=nil;

        ((CAShapeLayer *)self.layer).fillColor=[UIColor clearColor].CGColor;
        ((CAShapeLayer *)self.layer).strokeColor = self.graphColor.CGColor;
        ((CAShapeLayer *)self.layer).path = [self graphPathFromPoints].CGPath;
    }
}


- (UIBezierPath *)graphPathFromPoints{
    
    BOOL fill=self.fillColors.count;
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    
    
    for (NSInteger i=0;i<points.count;i++) {
        
        
        CGPoint point=[self pointAtIndex:i];
        
        if(i==0)
            [path moveToPoint:point];
        
        
        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:self.graphColor];
        button.layer.cornerRadius=3;
        button.frame=CGRectMake(0, 0, 6, 6);
        button.center=point;
        [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [self addSubview:button];
        
        [buttons addObject:button];
        
        [path addLineToPoint:point];
        
        
        
    }
    
    
    
    
    if (self.curved) {
        
        path=[path smoothedPathWithGranularity:20];
        
    }
    
    
    if(fill){
        
        CGPoint last=[self pointAtIndex:points.count-1];
        CGPoint first=[self pointAtIndex:0];
        [path addLineToPoint:CGPointMake(last.x,self.height)];
        [path addLineToPoint:CGPointMake(first.x,self.height)];
        [path addLineToPoint:first];
        
    }
    
    if (fill) {
        
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        
        gradient.mask=maskLayer;
    }
    
    
    path.lineWidth=self.lineWidth ? self.lineWidth : 1;
    
    
    return path;
}

- (CGPoint)pointAtIndex:(NSInteger)index{

    CGFloat space=(self.frame.size.width)/(points.count+1);

    
    return CGPointMake(space+(space)*index,self.height-((self.height-PADDING*2)*[[points objectAtIndex:index] floatValue]+PADDING));
}

- (void)tap:(UIButton *)button{
    
    
    if (label.superview) {
        __block UILabel *labelBK=label;
        [UIView animateWithDuration:.15 animations:^{
            labelBK.transform=CGAffineTransformMakeScale(0, 0);
        }completion:^(BOOL finished) {
            [labelBK removeFromSuperview]; labelBK=nil;
        }];
    }
    
    
    if (button.tag==currentTag) {
        currentTag=-1;
        return;
    }else currentTag=button.tag;
    
    label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=self.detailTextColor ? self.detailTextColor : ( _graphColor ? _graphColor : (_fillColors.count ? [UIColor colorWithCGColor:(CGColorRef)[_fillColors firstObject]] : self.graphColor) );
    label.backgroundColor=self.detailBackgroundColor;
    label.layer.borderColor=label.textColor.CGColor;
    label.layer.borderWidth=.5;
    if ([[self.values objectAtIndex:currentTag] isKindOfClass:[NSString class]]) {
        label.text=[self.values objectAtIndex:currentTag];
    }else label.text=[NSString stringWithFormat:@"%@",[self.detailLabelFormatter stringFromNumber:[self.values objectAtIndex:currentTag]]];
    label.center=CGPointMake(button.center.x,button.center.y);
    label.layer.cornerRadius=3;
    label.clipsToBounds=YES;
    label.transform=CGAffineTransformMakeScale(0, 0);
    [self addSubview:label];
    [UIView animateWithDuration:.2 animations:^{
        label.transform=CGAffineTransformMakeScale(1, 1);
    }];
    
    
}





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




- (void)animate{
    
    self.waitToUpdate=NO;
    
    gradient.hidden=1;
    
    ((CAShapeLayer *)self.layer).fillColor=[UIColor clearColor].CGColor;
    ((CAShapeLayer *)self.layer).strokeColor = self.graphColor.CGColor;
    ((CAShapeLayer *)self.layer).path = [self graphPathFromPoints].CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = self.animationDuration;
    animation.delegate=self;
    [self.layer addAnimation:animation forKey:@"MPStroke"];

    

    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    
    CGFloat delay=((CGFloat)self.animationDuration)/(CGFloat)points.count;
    

    
    for (NSInteger i=0;i<points.count;i++) {
        
        
        CGPoint point=[self pointAtIndex:i];
        
        
        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:self.graphColor];
        button.layer.cornerRadius=3;
        button.frame=CGRectMake(0, 0, 6, 6);
        button.center=point;
        [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        button.transform=CGAffineTransformMakeScale(0,0);
        [self addSubview:button];
        
        [self performSelector:@selector(displayPoint:) withObject:button afterDelay:delay*i];
        
        [buttons addObject:button];
        
        
    }
    
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    
    gradient.hidden=0;
}


- (void)displayPoint:(UIButton *)button{
    
        [UIView animateWithDuration:.2 animations:^{
            button.transform=CGAffineTransformMakeScale(1, 1);
        }];
    
    
}

#pragma mark setters

-(void)setFillColors:(NSArray *)fillColors{
    
    
    
    [gradient removeFromSuperlayer]; gradient=nil;
    
    if(fillColors.count){
        
        NSMutableArray *colors=[[NSMutableArray alloc] initWithCapacity:fillColors.count];
        
        for (UIColor* color in fillColors) {
            if ([color isKindOfClass:[UIColor class]]) {
                [colors addObject:(id)[color CGColor]];
            }else{
                [colors addObject:(id)color];
            }
        }
        _fillColors=colors;
        
        gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = _fillColors;
        [self.layer addSublayer:gradient];
        
        
    }else     _fillColors=fillColors;
    
    
    [self setNeedsDisplay];
    
}

- (void)setValues:(NSArray *)values{
    
    if (values) {
        
        _values=[values copy];
        
        points=[self pointsForArray:_values];
        
        
        [self setNeedsDisplay];
    }
    
}

-(void)setCurved:(BOOL)curved{
    _curved=curved;
    [self setNeedsDisplay];
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


@end
