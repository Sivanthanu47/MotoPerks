//
//  VehicleAddFirstCustomCell.h
//  CarBook
//
//  Created by Raja Sekhar on 26/03/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleAddFirstCustomCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UITextField *txtOwner,*txtLic,*txtCarName,*txtVIN,*txtInsName,*txtCMRead,*txtFuel;
@property (nonatomic, retain) IBOutlet UIButton *btnDate,*btnReg,*btnTake,*btnPick,*btnFuelType;
@property (nonatomic, retain) IBOutlet UIImageView *ImgVehicle;
@property (nonatomic, retain)IBOutlet UITextView * Address;
@end
