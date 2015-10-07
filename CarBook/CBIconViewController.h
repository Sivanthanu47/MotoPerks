//
//  CBIconViewController.h
//  CarBook
//
//  Created by Raja T S Sekhar on 24/08/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBIconViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray * iconsArray;
    IBOutlet UITableView * iconTable;
}
@end
