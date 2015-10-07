//
//  CBAddVehicleSecondViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 11/11/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"

@class MBProgressHUD;

@interface CBAddVehicleSecondViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,MBProgressHUDDelegate> {
    IBOutlet UITableView *tblAddsecond,*tblchoice;
    NSMutableArray *arrSerName;
    NSMutableDictionary *getSerDict,*dictNotif;
    NSMutableDictionary *dictData;

}
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSMutableDictionary *addCarDetails;
@property (strong, nonatomic) NSMutableDictionary *dictData;


@property(strong, nonatomic) MBProgressHUD *HUD;
- (IBAction)saveCarDetails:(id)sender;
@end
