//
//  MPPlot.h
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"


#define PADDING 12

#define ANIMATIONDURATION 1.5

typedef NS_ENUM(NSUInteger, MPPlotType) {
    MPPlotTypeUnknown=0,
    MPPlotTypeGraph=1,
    MPPlotTypeBars=2,
    MPPlotTypeCake=3,
};

typedef CGFloat(^GraphPointsAlgorithm)(CGFloat x);


@interface MPPlot : UIView{
    
    MPPlotType plotType;
    
    UIColor *_graphColor;
    
    CGFloat _animationDuration;
    
    NSArray *points;
    
    NSMutableArray *buttons;

    UILabel *label;
    
    NSInteger currentTag;
    
    GraphPointsAlgorithm _customAlgorithm;
    
    NSUInteger _numberOfPoints;
}



// Abstract Class

+ (id)plotWithType:(MPPlotType)type frame:(CGRect)frame;



@property (nonatomic,copy) NSArray *values; // array of NSNumber or NSString
@property (nonatomic,retain) UIColor *graphColor; // color of the line
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) BOOL waitToUpdate;
@property (nonatomic,assign) CGFloat animationDuration;


// detail View customization
@property (nonatomic,retain) UIColor *detailBackgroundColor;
@property (nonatomic,retain) UIColor *detailTextColor;

@property (nonatomic,retain) NSNumberFormatter *detailLabelFormatter;


- (void)animate;

- (void)setAlgorithm:(GraphPointsAlgorithm)customAlgorithm numberOfPoints:(NSUInteger)numberOfPoints;

@end



@interface MPButton : UIButton

+ (id)buttonWithType:(UIButtonType)buttonType tappableAreaOffset:(UIOffset)tappableAreaOffset;

@end


