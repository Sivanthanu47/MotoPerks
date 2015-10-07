//
//  CBVehicleServiceStationAddController.h
//  CarBook
//
//  Created by Raja Sekhar on 10/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"

@class MBProgressHUD;

@interface CBVehicleServiceStationAddController : UIViewController <MBProgressHUDDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *tblSSAdd;
    NSMutableArray *arrUpdate,*arrStation,*arrDerStation;
}
@property(strong, nonatomic) MBProgressHUD *HUD;
@property(strong, nonatomic) NSString *SStanID;
- (IBAction)saveServiceStations:(id)sender;
@end
