//
//  CBVehicleStationDetailController.h
//  CarBook
//
//  Created by Raja Sekhar on 02/02/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBVehicleStationDetailController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    IBOutlet UITableView *tblViewStation;
    NSMutableArray *arrStan,*arrImg;
    IBOutlet UILabel *lblStationName,*lblAddress,*lblAddCity,*lblPhone,*lblContactNo,*lblNotes;
}
@property (strong, nonatomic) NSString *stationID;
- (IBAction)deleteStation;
@end
