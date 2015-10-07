//
//  CBChosenVehicleViewController.h
//  CarBook
//
//  Created by Raja T S Sekhar on 08/05/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CBChosenVehicleViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    IBOutlet UITableView * chosenVehicleTable;
    NSMutableArray *getCarName,*arrReturnCsvFile;
}
@property (nonatomic, strong) NSMutableArray *arrTrack,*arrSerLog;
@property (nonatomic, strong) NSString *_strVINID;
@property (nonatomic, strong) NSString *vehicleServiceId;
@property (nonatomic, strong) NSString *vehicleMileageId;
@property (nonatomic, strong) NSString *stationServiceId;
@property (nonatomic, strong) NSString *stationMileageId;
-(IBAction)Export:(id)sender;
@end
