//
//  CBVehicleServiceStationViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 10/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBVehicleServiceStationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *tblView;
    NSMutableArray *arrVecData;
}
@property (nonatomic, strong) NSString *StationId,*serStationName;
@end