//
//  CBVehicleMainViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 10/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBVehicleMainViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *tblMainView;
    IBOutlet UILabel * notificationLabel;
    NSMutableArray *arrMenuTitle;
    NSMutableArray * arrimgTitle;
}
- (IBAction)loadVehicleView;
- (IBAction)loadStationView;
- (IBAction)loadMapView;
- (IBAction)loadSettingView;
- (IBAction)loadReportView;
- (IBAction)loadExportView;
- (IBAction)loadServiceView:(id)sender;
- (IBAction)loadMileageView:(id)sender;
- (IBAction)loadAddFuel;
@end
