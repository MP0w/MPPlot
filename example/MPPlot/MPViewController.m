//
//  MPViewController.m
//  MPPlot
//
//  Created by Alex Manzella on 19/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPViewController.h"

@interface MPViewController ()

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    graph=[MPPlot plotWithType:MPPlotTypeGraph frame:CGRectMake(0, 30, 320, 150)];
    
//    NSMutableArray *arr=[[NSMutableArray alloc] init];
//    
//    for (NSInteger i=0; i<10; i++) {
//        [arr addObject:@([self cubex:i])];
//    }
//
    graph.fillColors=@[[UIColor colorWithRed:0.251 green:0.232 blue:1.000 alpha:1.000],[UIColor colorWithRed:0.282 green:0.945 blue:1.000 alpha:1.000]];
    graph.values=@[@2.5,@2.6,@2.8,@3,@3.3,@3,@3.6,@3.8,@3.2,@3.6,@4,@4.5];
    graph.graphColor=[UIColor colorWithRed:0.500 green:0.158 blue:1.000 alpha:1.000];
    graph.detailBackgroundColor=[UIColor colorWithRed:0.444 green:0.842 blue:1.000 alpha:1.000];
    graph.graphColor=[UIColor clearColor];

    [self.view addSubview:graph];
    
    
    graph2=[[MPGraphView alloc] initWithFrame:graph.frame];
    graph2.waitToUpdate=YES;
    graph2.values=@[@2.5,@2.6,@2.8,@3,@2.8,@3.2,@3.6,@4,@4.5,@5,@4,@3.6];
    //graph2.fillColors=@[[UIColor orangeColor],[UIColor colorWithRed:1.000 green:0.827 blue:0.000 alpha:1.000]];
    graph2.graphColor=[UIColor redColor];
    graph2.curved=YES;
    [self.view addSubview:graph2];
    
    
    graph3=[[MPGraphView alloc] initWithFrame:CGRectMake(0, 200, 320, 150)];
    graph3.waitToUpdate=YES;

    [graph3 setAlgorithm:^CGFloat(CGFloat x) {
        return sin((double)x);
    } numberOfPoints:13];
    
    graph3.curved=YES;
    
    graph3.graphColor=[UIColor colorWithRed:0.500 green:0.158 blue:1.000 alpha:1.000];
    graph3.detailBackgroundColor=[UIColor colorWithRed:0.444 green:0.842 blue:1.000 alpha:1.000];
    
    
    
    graph4=[[MPGraphView alloc] initWithFrame:graph3.frame];
    graph4.values=@[@2.5,@2.6,@2.8,@3.8,@3.2,@3.6,@4,@4.5,@2.6,@2.8,@3,@2.8,@3.2];
    graph4.fillColors=@[[UIColor orangeColor],[UIColor colorWithRed:1.000 green:0.827 blue:0.000 alpha:1.000]];
    graph4.graphColor=[UIColor redColor];
    graph4.curved=YES;
    [self.view addSubview:graph4];
    
    [self.view addSubview:graph3];
    
    
    graph5=[MPPlot plotWithType:MPPlotTypeBars frame:CGRectMake(0, 360, 320, 150)];
    graph5.waitToUpdate=YES;
    graph5.detailView=(UIView <MPDetailView> *)[self customDetailView];
    [graph5 setAlgorithm:^CGFloat(CGFloat x) {
        return tan(x);
    } numberOfPoints:8];
    graph5.graphColor=[UIColor colorWithRed:0.120 green:0.806 blue:0.157 alpha:1.000];
    [self.view addSubview:graph5];
    
    
    
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Animate" forState:UIControlStateNormal];
    button.frame=CGRectMake(30, self.view.height-40, self.view.width-60, 40);
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(animate) forControlEvents:UIControlEventTouchUpInside];

}


- (UIView *)customDetailView{
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor blueColor];
    label.backgroundColor=[UIColor whiteColor];
    label.layer.borderColor=label.textColor.CGColor;
    label.layer.borderWidth=.5;
    label.layer.cornerRadius=label.width*.5;
    label.adjustsFontSizeToFitWidth=YES;
    label.clipsToBounds=YES;
    
    return label;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(animate) withObject:nil afterDelay:1];

}

- (void)animate{
    
    [graph2 animate];
    [graph3 animate];
    [graph5 animate];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
