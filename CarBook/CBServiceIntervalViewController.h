//
//  CBServiceIntervalViewController.h
//  CarBook
//
//  Created by Raja T S Sekhar on 17/08/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBServiceIntervalViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UILabel * lblKm;
    IBOutlet UILabel * lblMonth;
    NSArray * monthArray;
    UIToolbar *pickerToolbar;
    UIPickerView *myPickerView;
    UIView* popoverView;
    NSArray * kmArray;
    IBOutlet UIButton * monthBtn;
    IBOutlet UIButton * KmBtn;

}
-(IBAction)byMonth:(id)sender;
-(IBAction)next:(id)sender;
@end
