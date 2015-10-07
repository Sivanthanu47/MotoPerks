//
//  CBVehicleServiceStationLogController.h
//  CarBook
//
//  Created by Raja Sekhar on 30/03/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBVehicleServiceStationLogController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *arrSerLog,*arrTemLog;
    IBOutlet UITableView *tblStationLog;
}
@property(strong, nonatomic) NSString *strVINID;
@end
