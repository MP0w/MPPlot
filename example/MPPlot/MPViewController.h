//
//  MPViewController.h
//  MPPlot
//
//  Created by Alex Manzella on 19/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPGraphView.h"
#import "MPPlot.h"
#import "MPBarsGraphView.h"

@interface MPViewController : UIViewController{
    
    MPGraphView *graph,*graph2,*graph3,*graph4;
    
    MPBarsGraphView *graph5;
    
}

@end
