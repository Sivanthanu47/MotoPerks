//
//  AppDelegate.m
//  CarBook
//
//  Created by Raja Sekhar on 05/11/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "CBDBMethods.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize mainPaths,db_path,dbPathFromApp,docsPath,filemanager;

- (id)init {
    self = [super init];
    if (self) {
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    
    wifiReachability = [Reachability reachabilityForLocalWiFi];
    [wifiReachability startNotifier];
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Constants sharedPath] settingsDefaults];
    mainPaths = [[Constants sharedPath] getDocumentPath];
    docsPath = [mainPaths objectAtIndex:0];
    db_path = [docsPath stringByAppendingPathComponent:DB_NAME];
    [self checkDataBase];
    // Override point for customization after application launch.
    if ([[[UIApplication sharedApplication] scheduledLocalNotifications] count]== 0)  {
        NSLog(@"vehicles Count %ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"Vehiclelist"]);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            startViewController = [[CBNoVehiclesViewController alloc] initWithNibName:@"CBNoVehiclesViewController" bundle:nil];
        } else {
            startViewController = [[CBNoVehiclesViewController alloc] initWithNibName:@"CBNoVehiclesViewController_iPad" bundle:nil];
        }
        // Override point for customization after app launch
        self.navigationController = [[UINavigationController alloc] init];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:self.navigationController];
        
        // Override point for customization after application launch.
        [self.navigationController pushViewController:startViewController animated:YES];
        [self.navigationController setNavigationBarHidden:YES];
        [self.window addSubview:self.navigationController.view];
        [self.window makeKeyAndVisible];
       


    }
    else{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleMainViewController alloc] initWithNibName:@"CBVehicleMainViewController" bundle:nil];
    } else {
        viewController = [[CBVehicleMainViewController alloc] initWithNibName:@"CBVehicleMainViewController_iPad" bundle:nil];
    }
        // Override point for customization after app launch
        self.navigationController = [[UINavigationController alloc] init];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:self.navigationController];
        
        // Override point for customization after application launch.
        [self.navigationController pushViewController:viewController animated:YES];
        [self.navigationController setNavigationBarHidden:YES];
        [self.window addSubview:self.navigationController.view];
        [self.window makeKeyAndVisible];
        

    }
     UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
       if (locationNotification) {
        application.applicationIconBadgeNumber = 0;
    }
    return YES;
}

- (void)checkDataBase {
    BOOL success;
    filemanager = [NSFileManager defaultManager];
    success = [filemanager fileExistsAtPath:db_path];
    NSLog(@"DataBase Path %@",db_path);
    if (success) {
        return;
    } else {
        database = [FMDatabase databaseWithPath:db_path];
        [database open];
        [database executeUpdate:@"create table tblVehicleDetails(VDId INTEGER  PRIMARY KEY, CarName text,InsuranceDate text,RegisterDate text,FuelType text,CMRead text,Owner text,Address text,FirstService text,ServiceMonthInterval text,ServiceKmInterval text,LSDate text,Sellername text,ownerAddr text,Note text,PhotoURL text)"];
        
        [database executeUpdate:@"create table tblServiceStation(SSId INTEGER  PRIMARY KEY,StationName text,AddCity text,Address text,PhoneNo text,ContactNo text,Notes text,Latitude text,Longitude text)"];
        
        [database executeUpdate:@"create table tblTrackMileage(TMId INTEGER  PRIMARY KEY,Rate integer,Quantity float,fuelCost float,CMRead text,CarName text,StationName text,Date text)"];
        
        [database executeUpdate:@"create table tblNotification(NFId INTEGER  PRIMARY KEY,CarName text,StationName text,Date text,TravelKM text,ServiceInterval text,VDId integer,SSId integer)"];
        
        [database executeUpdate:@"create table tblServiceDetails(SDId INTEGER  PRIMARY KEY,CarName text,StationName text,Date text,Cost text,TypeOfService text,Notes text,VDId integer,SSId integer)"];
        
        [database close];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    application.applicationIconBadgeNumber = 0;
    [[Constants sharedPath] setLocalNotification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    /*NSLog(@"Received Notification %@",notification);
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:DATEFORMAT];*/
    /*NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *difference = [calendar components:notification.repeatInterval
                                               fromDate:notification.fireDate
                                                 toDate:[NSDate date]
                                                options:0];
    NSDate *nextFireDate = [calendar dateByAddingComponents:difference
                                                     toDate:notification.fireDate
                                                    options:0];*/
    /*NSString* nextdate = [format stringFromDate:[NSDate date]];
    if ([[notification.userInfo objectForKey:@"NextServiceDate"] isEqualToString:nextdate]) {
        NSString *notiDate = [[Constants sharedPath] getNextServiceDate:[notification.userInfo objectForKey:@"NextServiceDate"] withMonth:[notification.userInfo objectForKey:@"ServiceInterval"]];
        NSMutableDictionary *dictNoti = [[NSMutableDictionary alloc] init];
        [dictNoti setObject:notiDate forKey:@"NextServiceDate"];
        [dictNoti setObject:[notification.userInfo objectForKey:@"NFId"] forKey:@"NFId"];
        NSLog(@"Next Fire Notification %@",dictNoti);
        //[[CBDBMethods sharedTools] updateLocalNotification:dictNoti];
        //[[UIApplication sharedApplication] cancelLocalNotification:notification];
    }*/
    /*UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }*/
    application.applicationIconBadgeNumber = 0;
    [[Constants sharedPath] setLocalNotification];
}

#pragma mark - Network Methods

-(void) checkNetworkStatus:(NSNotification *)notice {
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable: {
            NSLog(@"The internet is down.");
            internetStatus = NO;
            break;
        }
        case ReachableViaWiFi: {
            NSLog(@"The internet is working via WIFI.");
            internetStatus = YES;
            break;
        }
        case ReachableViaWWAN: {
            NSLog(@"The internet is working via WWAN.");
            internetStatus = YES;
            break;
        }
    }
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus) {
        case NotReachable: {
            NSLog(@"A gateway to the host server is down.");
            hostStatus= NO;
            break;
        }
        case ReachableViaWiFi: {
            NSLog(@"A gateway to the host server is working via WIFI.");
            hostStatus = YES;
            break;
        }
        case ReachableViaWWAN: {
            NSLog(@"A gateway to the host server is working via WWAN.");
            hostStatus = YES;
            break;
        }
    }
}

@end
