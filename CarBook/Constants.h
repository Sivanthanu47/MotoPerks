//
//  Constants.h
//  DMRecognizer
//
//  Created by Raja Sekhar on 30/10/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#define DB_NAME             @"CarBook.sqlite"
#define DATEFORMAT          @"dd/MMM/yyyy"

#define kBorderWidth 1.5
#define kCornerRadius 4.0

#define kGOOGLE_API_KEY @"AIzaSyD5jZSkhKFWMf0Edyyv3riCtUXuuc8OAx4"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

typedef enum ColorModes : NSInteger {
    cTextColor,
    cBGColor,
} ColorMode;

enum {
    TS_IDLE,
    TS_INITIAL,
    TS_RECORDING,
    TS_PROCESSING,
} transactionState;

@interface Constants : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

+ (id)sharedPath;

- (NSArray *)getDocumentPath;

- (NSMutableArray *)getCurrentLocation:(NSString *)strStation;

- (NSString *)getNextServiceDate:(NSString *)lastdate withMonth:(NSString *)day;

-(void)setLocalNotification;

-(void)settingsDefaults;

- (BOOL)isNetworkAvailable;

@end
