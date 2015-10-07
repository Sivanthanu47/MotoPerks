//
//  Constants.m
//  DMRecognizer
//
//  Created by Raja Sekhar on 30/10/13.
//
//


#import "Constants.h"
#import "CBDBMethods.h"
#import "Reachability.h"

@implementation Constants

+ (id)sharedPath {
    static Constants *sharedpath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedpath = [[self alloc] init];
    });
    return sharedpath;
}

- (NSArray *)getDocumentPath {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return path;
}

#pragma mark - CLLocationManagerDelegate

-(CLLocationCoordinate2D) getLocation {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
}

- (NSMutableArray *)getCurrentLocation:(NSString *)strStation {
    NSMutableArray *arrLocation = [[NSMutableArray alloc] init];
    NSMutableArray *arrKM = [[NSMutableArray alloc] init];
    if (strStation == nil) {
        [arrLocation addObjectsFromArray:[[CBDBMethods sharedTools] getServiceStationDetails]];
    } else {
        [arrLocation addObjectsFromArray:[[CBDBMethods sharedTools] getStationWithMap:strStation]];
    }
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    CLLocation *current = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    for (NSDictionary *dict in arrLocation) {
        CLLocation *itemLoc = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"Latitude"] doubleValue] longitude:[[dict objectForKey:@"Longitude"] doubleValue]];
        double distance = [itemLoc distanceFromLocation:current] / 1000;
        NSLog(@"distance %f",distance);
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:[dict objectForKey:@"stationName"] forKey:@"stationName"];
        [dictionary setObject:[dict objectForKey:@"AddCity"] forKey:@"AddCity"];
        [dictionary setObject:[dict objectForKey:@"PhoneNo"] forKey:@"PhoneNo"];
        [dictionary setObject:[dict objectForKey:@"ContactNo"] forKey:@"ContactNo"];
        [dictionary setObject:[dict objectForKey:@"Address"] forKey:@"Address"];
        [dictionary setObject:[NSString stringWithFormat:@"%.f Km",distance] forKey:@"distance"];
        [arrKM addObject:dictionary];
    }
    return arrKM;
}

- (NSString *)getNextServiceDate:(NSString *)lastdate withMonth:(NSString *)day {
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:DATEFORMAT];
    NSDate *currentDate = [[NSDate alloc] init];
    currentDate = [format dateFromString:lastdate];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.month = [day integerValue];
    NSDate *currentDatePlusMonth = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    NSString* nextdate = [format stringFromDate:currentDatePlusMonth];
    return nextdate;
}

-(void)notificationAdded:(NSMutableDictionary *)notiDict {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:DATEFORMAT];
    NSDate *pickerDate = [[NSDate alloc] init];
    pickerDate = [format dateFromString:[notiDict objectForKey:@"NextServiceDate"]];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    BOOL week = [[NSUserDefaults standardUserDefaults] boolForKey:@"Week"];
    dateComponents.day = -7;
    if (week) {
        dateComponents.weekOfMonth = -1;
    }
    NSDate *firedate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:pickerDate options:0];
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = firedate;
    //localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:[[notiDict objectForKey:@"ServiceInterval"] integerValue]];
    localNotification.alertBody = [NSString stringWithFormat:@"Car Name: %@\tStation Name: %@",[notiDict objectForKey:@"CarName"],[notiDict objectForKey:@"stationName"]];
    //localNotification.alertAction = [NSString stringWithFormat:@"%@",[notiDict objectForKey:@"CarName"]];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.userInfo = notiDict;
    localNotification.repeatInterval = NSDayCalendarUnit;
    localNotification.applicationIconBadgeNumber = [localNotification applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)setLocalNotification {
    BOOL notifin = [[NSUserDefaults standardUserDefaults] boolForKey:@"Notification"];
    if (notifin) {
        NSMutableArray *arrGetNot = [[NSMutableArray alloc] init];
        NSArray *arrNotifi = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:DATEFORMAT];
        NSString* nextdate = [format stringFromDate:[NSDate date]];
        for (UILocalNotification *notification in arrNotifi) {
            if ([[notification.userInfo objectForKey:@"NextServiceDate"] isEqualToString:nextdate]) {
                [[CBDBMethods sharedTools] deleteNotification:[notification.userInfo objectForKey:@"NFId"]];
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
        [arrGetNot addObjectsFromArray:[[CBDBMethods sharedTools] getNotificationDetail:nil]];
        for (NSMutableDictionary *dict in arrGetNot) {
            [self notificationAdded:dict];
        }
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    NSLog(@"Notification Count %d",[[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
}

-(void)settingsDefaults {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"fuel"] == NULL){
        [[NSUserDefaults standardUserDefaults] setObject:@"Litre" forKey:@"fuel"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Notification"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SMS"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EMail"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Application"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Week"];
    }
}

- (BOOL)isNetworkAvailable {
    Reachability *networkReachability = [Reachability  reachabilityForInternetConnection];
    Reachability *hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus hostStatus = [hostReachability currentReachabilityStatus];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable || hostStatus == NotReachable) {
        return NO;
    }
    return YES;
}

@end