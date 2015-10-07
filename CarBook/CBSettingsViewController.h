//
//  CBSettingsViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 12/01/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate> {
    IBOutlet UITableView *tblSettings;
    NSArray *arrFuel,*arrRem,*arrSendRem;
    UITextField * petrolText;
    UITextField * DieselText;
    UITextField * GasText;
    BOOL clearField;

}
@property(assign) NSIndexPath *checkedFuelIndexPath;
@end
