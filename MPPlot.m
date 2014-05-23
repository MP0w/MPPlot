//
//  MPPlot.m
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPPlot.h"
#import "MPGraphView.h"
#import "MPBarsGraphView.h"

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

        case MPPlotTypeBars:
            return [[MPBarsGraphView alloc] initWithFrame:frame];
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
    
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
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
    
    if (view==self && self.detailView.superview) {
        [UIView animateWithDuration:.15 animations:^{
            self.detailView.transform=CGAffineTransformMakeScale(0, 0);
        }completion:^(BOOL finished) {
            [self.detailView removeFromSuperview];
        }];
    }
    
    return view;
}



- (void)animate{
    
    self.waitToUpdate=NO;
    
    [self setNeedsDisplay];
}



#pragma mark Actions


- (void)tap:(UIButton *)button{
    
    if (button.tag==currentTag) {
        currentTag=-1;
    }else currentTag=button.tag;
    
    if (self.detailView.superview) {
        [UIView animateWithDuration:.15 animations:^{
            self.detailView.transform=CGAffineTransformMakeScale(0, 0);
        }completion:^(BOOL finished) {
            
            [self.detailView removeFromSuperview];
            
            if(currentTag>=0)
                [self displayDetailViewAtPoint:button.center];

        }];
        
    }else [self displayDetailViewAtPoint:button.center];

    
    

    
    
}

- (void)displayDetailViewAtPoint:(CGPoint)point{
    
    if ([[self.values objectAtIndex:currentTag] isKindOfClass:[NSString class]]) {
        self.detailView.text=[self.values objectAtIndex:currentTag];
    }else self.detailView.text=[NSString stringWithFormat:@"%@",[self.detailLabelFormatter stringFromNumber:[self.values objectAtIndex:currentTag]]];
    
    
    self.detailView.center=point;
    self.detailView.transform=CGAffineTransformMakeScale(0, 0);
    
    [self addSubview:self.detailView];
    
    [UIView animateWithDuration:.2 animations:^{
        self.detailView.transform=CGAffineTransformMakeScale(1, 1);
    }];
    

}


-(UIView <MPDetailView> *)detailView{
    
    if (_detailView) {
        return _detailView;
    }
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=self.detailTextColor ? self.detailTextColor : ( self.graphColor );
    label.backgroundColor=self.detailBackgroundColor;
    label.layer.borderColor=label.textColor.CGColor;
    label.layer.borderWidth=.5;
    label.layer.cornerRadius=3;
    label.adjustsFontSizeToFitWidth=YES;
    label.clipsToBounds=YES;
    
    self.detailView=(UILabel <MPDetailView> *)label;

    return _detailView;
}


@end




@implementation MPButton

UIOffset tappableAreaOffset;

+ (id)buttonWithType:(UIButtonType)buttonType tappableAreaOffset:(UIOffset)tappableAreaOffset_{
    
    tappableAreaOffset=tappableAreaOffset_;
    
    return [super buttonWithType:buttonType];
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    return CGRectContainsPoint(CGRectInset(self.bounds,  -tappableAreaOffset.horizontal, -tappableAreaOffset.vertical), point);
    
}

@end
