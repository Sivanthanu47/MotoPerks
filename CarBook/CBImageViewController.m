//
//  CBImageViewController.m
//  CarBook
//
//  Created by Raja T S Sekhar on 21/08/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//
#import "CBAddVehicleFirstViewController.h"
#import "CBAddVehicleSecondViewController.h"
#import "CBImageViewController.h"
#import "CBStrings.h"
#import "OverlayView.h"
#import "CBIconViewController.h"
#import "CBDBMethods.h"
#import "CBVehicleViewController.h"
@interface CBImageViewController ()

@end
NSString *fileformatName;

@implementation CBImageViewController
@synthesize addCarDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    imageArray = [[NSMutableArray alloc]initWithObjects:@"Pick predefined icon",@"Pick from gallery",@"Take photo", nil];
    
    picker = [[UIImagePickerController alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor =[[CBStrings sharedStrings]colorFromString:@"494949"];
    self.navigationController.navigationBar.backgroundColor =[[CBStrings sharedStrings]colorFromString:@"494949"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [imageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [imageArray objectAtIndex:indexPath.row];
    cell.backgroundColor =[UIColor clearColor];
    cell.textLabel.textColor = [[CBStrings sharedStrings]colorFromString:@"2B4074"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        [self predefinedIcon];
    }
    else if (indexPath.row==1){
        [self galleryImages];
        
    }
    else{
        [self Takephoto];
    }
}
-(IBAction)done:(id)sender{
    NSMutableArray *key = [[NSMutableArray alloc] initWithObjects:@"PhotoURL", nil];
    [key addObjectsFromArray:[addCarDetails allKeys]];
    NSMutableArray *value = [[NSMutableArray alloc] initWithObjects:strPhotoURL, nil];
    [value addObjectsFromArray:[addCarDetails allValues]];
    __block BOOL isNull = NO;
    [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@" gl"] || [obj isEqualToString:@" lr"] || [obj isEqualToString:@""] || (obj == nil)) {
            *stop = YES;
            isNull = YES;
        }
    }];
    if (isNull == YES) {
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                           message:[[CBStrings sharedStrings] getAlertMessage:@"ErrorAddVehicleDetail"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [addAlert show];
        return;
    }
    NSMutableDictionary *Dict = [[NSMutableDictionary alloc] initWithObjects:value forKeys:key];
    [self getCachesPath:Dict];

}
- (void)getCachesPath:(NSMutableDictionary *)dict {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"PhotoURL"]]];
    NSString __block *path;
    ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef imageRef = [representation fullScreenImage];
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithInteger: timeStamp];
        fileformatName = [[asset defaultRepresentation] filename];
        NSArray * subStr = [fileformatName componentsSeparatedByString:@"."];
        NSData *imgData;
        if ([[fileformatName pathExtension] isEqualToString:@"JPG"]) {
            imgData = UIImageJPEGRepresentation(image, 1.0);
        } else {
            imgData = UIImagePNGRepresentation(image);
        }
        NSArray *paths = [[Constants sharedPath] getDocumentPath];
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString  stringWithFormat:@"%@_%@.%@",[subStr objectAtIndex:0],timeStampObj,[subStr objectAtIndex:1]]];
        [[NSFileManager defaultManager] createFileAtPath:path contents:imgData attributes:nil];
        NSString *NextServiceDate = [[Constants sharedPath] getNextServiceDate:[dict objectForKey:@"LastServiceDate"] withMonth:[dict objectForKey:@"ServiceInterval"]];
        [dict setObject:[NSString  stringWithFormat:@"%@_%@.%@",[subStr objectAtIndex:0],timeStampObj,[subStr objectAtIndex:1]] forKey:@"PhotoURL"];
        [dict setObject:NextServiceDate forKey:@"NextServiceDate"];
        [[CBDBMethods sharedTools] insertVehicles:dict];
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                           message:[[CBStrings sharedStrings] getAlertMessage:@"AddVehicleDetail"]
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [addAlert show];
       // NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[CBDBMethods sharedTools] getVehicleDetails]];
//NSMutableDictionary *duplicateDict = [arr lastObject];
//[dict setObject:[duplicateDict objectForKey:@"VDId"] forKey:@"VDId"];
        dictNotif = dict;
    };
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
    };
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:url resultBlock:resultsBlock failureBlock:failureBlock];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[CBDBMethods sharedTools] insertNotification:dictNotif];
    [[Constants sharedPath] setLocalNotification];
    [self goHome];
    
}
- (void)goHome {
    UIViewController * viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleViewController alloc] initWithNibName:@"CBVehicleViewController" bundle:nil];
    } else {
        viewController = [[CBVehicleViewController alloc] initWithNibName:@"CBVehicleViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];

}
-(IBAction)predefinedIcon{
    UIViewController * viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBIconViewController alloc] initWithNibName:@"CBIconViewController" bundle:nil];
    } else {
        viewController = [[CBIconViewController alloc] initWithNibName:@"CBIconViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
-(IBAction)galleryImages{
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:picker animated:YES completion:nil];
}

-(IBAction)Takephoto;{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self loadCamera];
    } else {
        UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Camera"
                                                                message:@"Camera Not Available"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
        [noCameraAlert show];
    }

}
-(void)loadCamera {
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-55, self.view.frame.size.width, 55)];
    switchCameraButton = [[UIBarButtonItem alloc] initWithTitle:@"Front" style:UIBarButtonItemStylePlain  target:self action:@selector(switchCamera)];
    toolBar.barStyle =  UIBarStyleBlackOpaque;
    NSArray *items=[NSArray arrayWithObjects:
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(shootPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    switchCameraButton,
                    nil];
    [toolBar setItems:items];
    OverlayView *overlayView=[[OverlayView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-55)];
    overlayView.opaque=NO;
    overlayView.backgroundColor=[UIColor clearColor];
    UIView *cameraView=[[UIView alloc] initWithFrame:self.view.bounds];
    [cameraView addSubview:overlayView];
    [cameraView addSubview:toolBar];
    picker.delegate = (id)self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.allowsEditing = NO ;
    picker.toolbarHidden = YES;
    picker.navigationBarHidden = YES;
    picker.showsCameraControls = NO;
    [picker setCameraOverlayView:cameraView];
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)shootPicture {
    [picker takePicture];
}
- (void)cancelPicture {
    [self dismissViewControllerAnimated:NO completion:NULL];
}
- (void)switchCamera {
    if(picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        switchCameraButton.title = @"Front";
    } else {
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        switchCameraButton.title = @"Rear";
    }
}
- (void)imagePickerController:(UIImagePickerController *)pic didFinishPickingMediaWithInfo:(NSDictionary *)info {
    pickedImage.image = info [UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        NSData *data = UIImageJPEGRepresentation(pickedImage.image, 1.0);
        [self toSavePhotoToCameraRoll:data];
    } else {
        strPhotoURL = [NSString stringWithFormat:@"%@",info [UIImagePickerControllerReferenceURL]];
    }
    [pic dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pic {
    [pic dismissViewControllerAnimated:YES completion:NULL];
}
- (void)toSavePhotoToCameraRoll:(NSData *)data {
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        [lib assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 strPhotoURL = [NSString stringWithFormat:@"%@",assetURL];
             } failureBlock:^(NSError *error) {
             }];
    }];
}

@end
