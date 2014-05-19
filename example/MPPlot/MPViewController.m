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
    graph=[[MPGraphView alloc] initWithFrame:CGRectMake(0, 30, 320, 200)];
    
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
    [self.view addSubview:graph];
    
    
    graph2=[[MPGraphView alloc] initWithFrame:CGRectMake(0, 250, 320, 200)];
    graph2.values=@[@2.5,@2.6,@2.8,@3,@2.8,@3.2,@3.6,@4,@4.5,@5,@4,@3.6];
    //graph2.fillColors=@[[UIColor orangeColor],[UIColor colorWithRed:1.000 green:0.827 blue:0.000 alpha:1.000]];
    graph2.curved=YES;
    graph2.graphColor=[UIColor redColor];
    [self.view addSubview:graph2];
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [graph animate];
    [graph2 animate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
