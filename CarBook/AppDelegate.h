//
//  AppDelegate.h
//  CarBook
//
//  Created by Raja Sekhar on 05/11/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBVehicleMainViewController.h"
#import "FMDatabase.h"
#import "Reachability.h"
#import "CBNoVehiclesViewController.h"

@class CBVehicleMainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    CBVehicleMainViewController *viewController;
    CBNoVehiclesViewController * startViewController;
    FMDatabase *database;
    Reachability *internetReachable;
    Reachability *hostReachable;
    Reachability *wifiReachability;
    NSMutableArray * getCarName;
}
@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, assign) NSArray *mainPaths;
@property (nonatomic, assign) NSFileManager *filemanager;
@property (nonatomic, assign) NSString *docsPath, *db_path, *dbPathFromApp;

@end

