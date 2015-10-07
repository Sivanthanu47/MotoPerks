//
//  CBServiceIntervalViewController.m
//  CarBook
//
//  Created by Raja T S Sekhar on 17/08/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBServiceIntervalViewController.h"
#import "CBImageViewController.h"
@interface CBServiceIntervalViewController ()

@end
NSArray *cellNib;
int ImgEdgeHieght;
int pickerHeight = 0;
int btnTag;
NSString * monthType,*kmType;
@implementation CBServiceIntervalViewController

- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItems = [self getTopMenuLeft];
}
- (NSMutableArray *)getTopMenuLeft {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    CGRect frameimgdeveloper = CGRectMake(0, 0, 44, 27);
    UIButton *btnDeveloper = [[UIButton alloc] initWithFrame:frameimgdeveloper];
    [btnDeveloper setTitle:@"Back" forState:UIControlStateNormal];
    [btnDeveloper setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    pickerHeight = 216;
    // Do any additional setup after loading the view from its nib.
    monthArray = [NSArray arrayWithObjects:@"every 4 months",@"every 6 months",@"every 8 months",@"every 10 months",@"every 12 months", nil];
    kmArray = [NSArray arrayWithObjects:@"every 500 kms",@"every 1000 kms",@"every 2000 kms",@"every 3000 kms",@"every 4000 kms",@"every 5000 kms",@"every 6000 kms",@"every 7000 kms",@"every 10000 kms", nil];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"kmType"] == NULL&& [[NSUserDefaults standardUserDefaults]objectForKey:@"monthType"] == NULL) {
        lblMonth.text = @"Service Interval is Set to every 4 months from last service date ";
        lblKm.text =@"Service Interval is Set to every 4000 kmsfrom current kilometer reading ";
        [KmBtn setTitle:@"every 500 kms" forState:UIControlStateNormal];
        [monthBtn setTitle:@"every 4 months" forState:UIControlStateNormal];
    }
    else{
    NSString * monthStr = [NSString stringWithFormat:@"Service Interval is Set to %@ from last service date ",[[NSUserDefaults standardUserDefaults]objectForKey:@"monthType"]];
    NSString * kmStr = [NSString stringWithFormat:@"Service Interval is Set to %@ from current kilometer reading ",[[NSUserDefaults standardUserDefaults]objectForKey:@"kmType"]];
    lblMonth.text = monthStr;
    lblKm.text =kmStr;
    [KmBtn setTitle:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"kmType"]] forState:UIControlStateNormal];
    [monthBtn setTitle:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"monthType"]] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)byMonth:(UIButton *)sender{
    [self addPicker];
    btnTag = sender.tag;
    [myPickerView reloadAllComponents];
}

-(void)addPicker{
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancel:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone)];
    [pickerToolbar setItems:@[cancelBtn,flexSpace, doneBtn] animated:NO];
    myPickerView = [[UIPickerView alloc] init];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    CGRect pickerRect = myPickerView.bounds;
    myPickerView.bounds = pickerRect;
    myPickerView.frame = CGRectMake(self.view.frame.origin.x, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, pickerHeight);
    myPickerView.showsSelectionIndicator = YES;
    popoverView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + pickerHeight)), self.view.frame.size.width, (self.navigationController.navigationBar.frame.size.height + pickerHeight))];
    NSLog(@" navigatio height %f",(self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + pickerHeight)));
    popoverView.backgroundColor = [UIColor whiteColor];
    [popoverView addSubview:myPickerView];
    [popoverView addSubview:pickerToolbar];
    [self.view addSubview:popoverView];
    monthType = @"every 4 months";
    kmType = @"every 500 kms";
}
-(void)pickerDone{
    if (btnTag == 0){
    NSString * monthStr = [NSString stringWithFormat:@"Service Interval is Set to %@ from last service date ",monthType];
        lblMonth.text = monthStr;
        [monthBtn setTitle:[NSString stringWithFormat:@"%@",monthType] forState:UIControlStateNormal];
    }
    else{
    NSString * kmStr = [NSString stringWithFormat:@"Service Interval is Set to %@ from current kilometer reading ",kmType];
    
    lblKm.text =kmStr;
    [KmBtn setTitle:[NSString stringWithFormat:@"%@",kmType] forState:UIControlStateNormal];
    }
    [myPickerView removeFromSuperview];
    [pickerToolbar removeFromSuperview];
    [popoverView removeFromSuperview];
    [myPickerView reloadAllComponents];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (btnTag == 0) {
        monthType = [monthArray objectAtIndex:row];
        [[NSUserDefaults standardUserDefaults]setObject:monthType forKey:@"monthType"];
        
    }else{
        kmType =[kmArray objectAtIndex:row];
        [[NSUserDefaults standardUserDefaults]setObject:kmType forKey:@"kmType"];
        
    }
       [myPickerView reloadAllComponents];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
     if (btnTag == 0) {
       return monthArray.count;
     }
     else{
         return kmArray.count;
     }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (btnTag == 0) {
        return [monthArray objectAtIndex:row];
    }
    else{
        return [kmArray objectAtIndex:row];
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    return sectionWidth;
}
-(void)pickerCancel:(id)sender{
    popoverView.hidden=TRUE;
}
-(IBAction)next:(id)sender{
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBImageViewController alloc] initWithNibName:@"CBImageViewController" bundle:nil];
    } else {
        viewController = [[CBImageViewController alloc] initWithNibName:@"CBImageViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
