//
//  CBTrackMileageAddViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 23/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTrackMileageAddViewController : UIViewController <UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate> {
    IBOutlet UITableView *tblcar,*tblTxtField;
    NSMutableArray *arrCarData;
    NSString *strKm ;
}

- (IBAction)savedTrackDetails;
@end
