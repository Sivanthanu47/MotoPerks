//
//  CBNoVehiclesViewController.h
//  CarBook
//
//  Created by Raja T S Sekhar on 12/08/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBNoVehiclesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
IBOutlet UITableView *tblMainView;
NSMutableArray *arrMenuTitle;
}
-(IBAction)Continue:(id)sender;
@end
