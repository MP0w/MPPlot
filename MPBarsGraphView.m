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
        
        [label removeFromSuperview]; label=nil;
        
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
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
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
    label.textColor=self.detailTextColor ? self.detailTextColor : ( self.graphColor );
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


- (void)animate{
    
    self.waitToUpdate=NO;
    
    shouldAnimate=YES;
    
    [self setNeedsDisplay];
}







@end
