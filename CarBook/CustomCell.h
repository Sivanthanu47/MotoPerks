//
//  CustomCell.h
//  CustomUITableViewCell
//
//  Created by Kshitiz Ghimire on 3/18/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, retain) IBOutlet UILabel *carlbl,*stationlbl,*totcatlbl,*datelbl,*costlbl,*typelbl;
@property (nonatomic, retain) IBOutlet UITextField *txtCost;
@property (nonatomic, retain) IBOutlet UITextView *txtNote,*txtNoteLbl;
@property (nonatomic, retain) IBOutlet UIButton *btnType,*btnDelete,*btnAdd,*btnMonth,*btnKM,*btnRate,*btnQuantity,*btnCost;
@property (nonatomic, retain) IBOutlet UITextField *txtServName,*txtAddPlace,*txtAddCity,*txtPhone,*txtEmail,*txtMap;
@property (nonatomic, retain) IBOutlet UIImageView *imgServName,*imgAddPlace,*imgAddCity,*imgPhone,*imgEmail,*imgMap;
@property (nonatomic, retain) IBOutlet UITextField *txtCarName,*txtVIN,*txtOwner,*txtLic,*txtInsName,*txtCMRead,*txtFuel,*txtSerInterval,*txtKm,*txtFuelType,* txtContact,*serviceAddr,*Notes;
@property (nonatomic, retain) IBOutlet UITextView *txtViewNote;
@property (nonatomic, retain) IBOutlet UIButton *btnDate,*btnReg,*btnSerName,*btnLDate,*btnTake,*btnPick,*btnFuelType;
@property (nonatomic, retain) IBOutlet UIImageView *imgView,*FirstarrImgView,*SectarrImgView;
@property (nonatomic, retain) IBOutlet UITextField *txtGasName,*txtTrackCMRead,*txtTrackFuel,*txtTrackKM,*txtRate,*txtQuantity,*txtVicinity;
@property (nonatomic, retain) IBOutlet UIButton *btnTrackCar,*btnGasName;
@property (nonatomic, retain) IBOutlet UILabel *lblTrackDate,*lblFuelType;
@property (nonatomic, retain) IBOutlet UIButton *btnMapPin;
@property (nonatomic, retain) IBOutlet UILabel *lblStationName,*lblStationAdd,*lblStationKm,*lblkmChange,*lblMonthChange;
@end
