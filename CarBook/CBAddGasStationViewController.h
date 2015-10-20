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
#import <MapKit/MapKit.h>

@class MBProgressHUD;
@interface CBAddGasStationViewController : UIViewController<MBProgressHUDDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *arrGasStation;
    IBOutlet UITableView *tblGas;
    IBOutlet UIButton * frequentStation,*NearByStations;
    IBOutlet UIImageView * frequentImg,*nearByImage;
    NSDictionary *gasDict;
    NSDictionary * gasSelectDict;
    CLLocationManager *locationManager;
}
@property(strong, nonatomic) MBProgressHUD *HUD;

-(IBAction)SelectedButton:(id)sender;
@end
