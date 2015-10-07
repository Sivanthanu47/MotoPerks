//
//  CBVehicleServiceDetailViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 11/02/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CBVehicleServiceDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate> {
    IBOutlet UITableView *tblService,*tblRepair;
    NSMutableArray *arrService,*arrCar,*arrType,*arrNotifi;
}
@property (strong, nonatomic) NSString *VehicleID;
@end
