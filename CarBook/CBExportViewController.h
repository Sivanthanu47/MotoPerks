//
//  CBExportViewController.h
//  CarBook
//
//  Created by Raja T S Sekhar on 01/05/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
@interface CBExportViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate> {
    NSArray * arrExportTitle;
    IBOutlet UITableView * exportTable;
    NSIndexPath * lastIndexPath;
    BOOL action;
    FMDatabase *database;
    NSMutableArray * dbArray,*arrReturnCsvFile,* vehicleDbArray,* stationDbArray,*arrVehData,*arrServiceLog;
    NSMutableArray * getCarName;
    NSMutableArray * arrSSDetails;
    NSMutableArray * arrTrack;
    NSArray * firstSection,* secondSection,* thirdSection;
}
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSString *strVehicleID,*strVehicleName;
@property (nonatomic, strong) NSMutableDictionary *editDict;
@property (nonatomic, strong) NSString *vehicleId;

@end
