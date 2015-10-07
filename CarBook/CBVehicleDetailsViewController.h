//
//  CBVehicleDetailsViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 22/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBVehicleDetailsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UITableView *tblVehicle;
    NSMutableArray *arrVehData,*arrServiceLog;
}
@property (strong, nonatomic) NSString *strVehicleID,*strVehicleName;
- (IBAction)deleteVehicle:(id)sender;
@end
