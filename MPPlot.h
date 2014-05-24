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


struct _MPValuesRange {
    CGFloat max;
    CGFloat min;
};

typedef struct _MPValuesRange MPGraphValuesRange;

NS_INLINE MPGraphValuesRange MPMakeGraphValuesRange(CGFloat min, CGFloat max) {
    MPGraphValuesRange r;
    r.min = min;
    r.max = max;
    return r;
}

NS_INLINE BOOL MPValuesRangeNULL(MPGraphValuesRange r) {
    return r.min==CGFLOAT_MIN && r.max==CGFLOAT_MAX;
}

NS_INLINE MPGraphValuesRange MPGetBiggestRange(MPGraphValuesRange r1,MPGraphValuesRange r2) {
    
    MPGraphValuesRange r;
    
    r.min=(r1.min<r2.min ? r1.min : r2.min);
    r.max=(r1.max>r2.max ? r1.max : r2.max);
    
    return r;
}

@protocol MPDetailView <NSObject>

- (void)setText:(NSString *)text;

@end

@interface MPPlot : UIView{
    
    MPPlotType plotType;
    
    UIColor *_graphColor;
    
    CGFloat _animationDuration;
    
    NSArray *points;
    
    NSMutableArray *buttons;
    
    NSInteger currentTag;
    
    GraphPointsAlgorithm _customAlgorithm;
    
    NSUInteger _numberOfPoints;
}



// Abstract Class

+ (id)plotWithType:(MPPlotType)type frame:(CGRect)frame;
+ (MPGraphValuesRange)rangeForValues:(NSArray *)values;


@property (nonatomic,copy) NSArray *values; // array of NSNumber or NSString
@property (nonatomic,retain) UIColor *graphColor; // color of the line
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) BOOL waitToUpdate;
@property (nonatomic,assign) CGFloat animationDuration;
@property (nonatomic,assign) MPGraphValuesRange valueRanges; // specify or read the max min... useful if you want to make 2 graph based on the same values, otherwise they would be inconsistent between them, for example graph of download has max 20 min 10 , and graph of updates has max 5 and min 0, without that the 20 and the 5 would be in the same place


// detail View customization
@property (nonatomic,readwrite) UIView<MPDetailView> *detailView;
@property (nonatomic,retain) UIColor *detailBackgroundColor;
@property (nonatomic,retain) UIColor *detailTextColor;
@property (nonatomic,retain) NSNumberFormatter *detailLabelFormatter;



- (void)animate;

- (void)setAlgorithm:(GraphPointsAlgorithm)customAlgorithm numberOfPoints:(NSUInteger)numberOfPoints;

- (void)tap:(UIButton *)button;

@end



@interface MPButton : UIButton

+ (id)buttonWithType:(UIButtonType)buttonType tappableAreaOffset:(UIOffset)tappableAreaOffset;

@end


