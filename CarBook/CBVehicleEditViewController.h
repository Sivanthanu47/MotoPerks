//
//  CBVehicleEditViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 03/03/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"

@class MBProgressHUD;

@interface CBVehicleEditViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {
    IBOutlet UITableView *tblEdit,*tblStationName;
    UIImagePickerController *picker;
    UIBarButtonItem* switchCameraButton;
    NSMutableArray *arrStaName;
    UIPickerView *myPickerView;
    NSArray *pickerArray;
    NSArray *arrFuelType;
    UIToolbar *pickerToolbar;
    UIView* popoverView;
}
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSMutableDictionary *editDict;
@property(strong, nonatomic) MBProgressHUD *HUD;
@end
