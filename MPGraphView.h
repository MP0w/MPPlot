//
//  MPGraphView.h
//
//
//  Created by Alex Manzella on 18/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"

#define PADDING 12

#define ANIMATIONDURATION 1.5


@interface MPGraphView : UIView{
    
    NSArray *points;
    
    NSMutableArray *buttons;
    CAGradientLayer *gradient;
    UILabel *label;
    
    NSInteger currentTag;
    

}



@property (nonatomic,copy) NSArray *values; // array of NSNumber or NSString
@property (nonatomic,retain) NSArray *fillColors; // array of colors or CGColor
@property (nonatomic,retain) UIColor *graphColor; // color of the line
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) BOOL curved;
@property (nonatomic,assign) CGFloat animationDuration;

// detail View customization
@property (nonatomic,retain) UIColor *detailBackgroundColor;
@property (nonatomic,retain) UIColor *detailTextColor;


- (void)animate;

@end
