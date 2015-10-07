//
//  LineChartViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 05/01/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface LineChartViewController : UIViewController <CPTPlotDataSource>
@property (nonatomic, strong) NSString *vehiName,*VehiID;
@property (nonatomic, strong) NSMutableArray *arrMilge,*arrDate,*arrGraphs;
@property (nonatomic, strong) CPTGraphHostingView *hostView;

@end