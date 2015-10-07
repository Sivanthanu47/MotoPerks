//
//  CBTrackMileageViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 30/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTrackMileageViewController : UIViewController <UIAlertViewDelegate>{
    IBOutlet UITextField *txtCar,*txtDate,*txtStation,*txtCMRead,*txtKM,*txtFuel;
    IBOutlet UIImageView *imgCar;
    IBOutlet UIButton * deleteButton;
}
@property (assign) BOOL isDeleteCheck;
@property (nonatomic, strong) NSMutableArray *arrTrack;
- (IBAction)deleteTrackMileage:(id)sender;
@end
