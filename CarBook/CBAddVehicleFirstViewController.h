//
//  CBAddVehicleViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 05/11/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBAddVehicleFirstViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UITextViewDelegate> {
    IBOutlet UITableView *tblAddFirst,*tblAddSecond;
    UIImagePickerController *picker;
    UIBarButtonItem* switchCameraButton;
    IBOutlet UIViewController *popDatePicker;
    UIPickerView *myPickerView;
    NSArray *pickerArray;
    NSArray *arrFuelType;
    UIToolbar *pickerToolbar;
    UIView* popoverView;
}
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)goNext:(id)sender;
@end
