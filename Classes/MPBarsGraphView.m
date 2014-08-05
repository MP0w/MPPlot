//
//  MPBarsGraphView.m
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPBarsGraphView.h"

@implementation MPBarsGraphView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        currentTag=-1;
        
        self.topCornerRadius=-1;
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    
    if (self.values.count && !self.waitToUpdate) {
        
        
        for (UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
        
        [self addBarsAnimated:shouldAnimate];
        
        [self.graphColor setStroke];

        UIBezierPath *line=[UIBezierPath bezierPath];
        
        [line moveToPoint:CGPointMake(PADDING, self.height)];
        [line addLineToPoint:CGPointMake(self.width-PADDING, self.height)];
        [line setLineWidth:1];
        [line stroke];
    }
}

- (void)addBarsAnimated:(BOOL)animated{
    
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    
    if (animated) {
        self.layer.masksToBounds=YES;
    }
    
    CGFloat barWidth=self.width/(points.count*2+1);
    CGFloat radius=barWidth*(self.topCornerRadius >=0 ? self.topCornerRadius : 0.3);
    for (NSInteger i=0;i<points.count;i++) {
        
        CGFloat height=[[points objectAtIndex:i] floatValue]*(self.height-PADDING*2)+PADDING;
        
        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom tappableAreaOffset:UIOffsetMake(barWidth/2, self.height)];
        [button setBackgroundColor:self.graphColor];
        button.frame=CGRectMake(barWidth+(barWidth*i+barWidth*i), animated ? self.height : self.height-height, barWidth, animated ? height+20 : height);
        
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = button.bounds;

        
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)].CGPath;

        button.layer.mask=maskLayer;
        
        [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [self addSubview:button];
        
        if (animated) {
            [UIView animateWithDuration:self.animationDuration delay:i*0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                button.y=self.height-height-20;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    button.frame=CGRectMake(barWidth+(barWidth*i+barWidth*i), self.height-height, barWidth, height);
                }];
            }];
        }
        
        [buttons addObject:button];
        
        

        
    }
    


    shouldAnimate=NO;
    
}

- (CGFloat)animationDuration{
    return _animationDuration>0.0 ? _animationDuration : .25;
}





- (void)animate{
    
    self.waitToUpdate=NO;
    
    shouldAnimate=YES;
    
    [self setNeedsDisplay];
}







@end
