//
//  CBImageViewController.h
//  CarBook
//
//  Created by Raja T S Sekhar on 21/08/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBImageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImage *chosenImage;
    IBOutlet UITableView * imageTable;
    NSMutableArray * imageArray;
    UIBarButtonItem* switchCameraButton;
    UIImagePickerController *picker;
    NSString *strPhotoURL;
    IBOutlet UIImageView * pickedImage;
    NSMutableDictionary *dictData,*dictNotif;

}
@property (strong, nonatomic) NSMutableDictionary *addCarDetails;
-(IBAction)done:(id)sender;
@end
