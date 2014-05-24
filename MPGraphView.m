//
//  MPGraphView.m
//
//
//  Created by Alex Manzella on 18/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPGraphView.h"
#import "UIBezierPath+curved.h"


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
        
        
        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom tappableAreaOffset:UIOffsetMake(25, 25)];
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



- (void)animate{
    
    if(self.detailView.superview)
        [self.detailView removeFromSuperview];

    
    
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

    self.waitToUpdate=NO;
    gradient.hidden=0;

}


- (void)displayPoint:(UIButton *)button{
    
        [UIView animateWithDuration:.2 animations:^{
            button.transform=CGAffineTransformMakeScale(1, 1);
        }];
    
    
}


#pragma mark Setters

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

-(void)setCurved:(BOOL)curved{
    _curved=curved;
    [self setNeedsDisplay];
}



@end
