//
//  CBAddGasStationViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 19/03/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@class MBProgressHUD;
@interface CBAddGasStationViewController : UIViewController<MBProgressHUDDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *arrGasStation;
    IBOutlet UITableView *tblGas;
    IBOutlet UIButton * frequentStation,*NearByStations;
    IBOutlet UIImageView * frequentImg,*nearByImage;

    CLLocationManager *locationManager;
}
@property(strong, nonatomic) MBProgressHUD *HUD;

-(IBAction)SelectedButton:(id)sender;
@end
