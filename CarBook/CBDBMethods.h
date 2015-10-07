//
//  VTFMDataBase.h
//  DMRecognizer
//
//  Created by Raja Sekhar on 10/03/14.
//
//

#import <Foundation/Foundation.h>
#import "FMDataBase.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <MessageUI/MessageUI.h>

@class AppDelegate;

@interface CBDBMethods : NSObject {
    FMDatabase *database;
}
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (nonatomic, retain) NSMutableArray *arrgetCarData;
+ (id)sharedTools;
-(void)insertVehicles:(NSMutableDictionary *)carDetails;
-(NSMutableArray *)getVehicleDetails;
-(void)insertServiceDetails:(NSMutableDictionary *)dict;
-(NSMutableArray *)getServiceStationDetails;
-(NSMutableArray *)getStationWithMap:(NSString *)stationID;
-(NSMutableArray *)getSingleVehicleDetail:(NSString *)vehicleID;
-(NSMutableArray *)getServiceStationVehicleLogs:(NSString *)VINID;
-(NSMutableArray *)getSingleStationwithVehicle:(NSString *)stationID;
-(void)inserTrackDetails:(NSMutableDictionary *)trackDetail;
-(NSMutableArray *)getTracksDetail;
-(void)deleteVehicle:(NSString *)VDid;
-(NSMutableArray *)getCorrespondingTrackID:(NSString *)trackID WithVehicle:(NSString *)vecID;
-(void)deleteTrackMileage:(NSString *)Trackid;
-(NSMutableArray *)getCMReadingCount:(NSString *)vid;
-(NSMutableArray *)searchingVehicleName:(NSString *)search;
-(NSMutableArray *)searchingServiceStationName:(NSString *)search;
-(NSMutableArray *)searchingTrackMileageName:(NSString *)search;
-(void)insertNotification:(NSMutableDictionary *)notifi;
-(NSMutableArray *)getNotificationDetail:(NSString *)strId;
-(void)deleteNotification:(NSString *)notiid;
-(void)updateLocalNotification:(NSMutableDictionary *)dict;
-(void)inserServiceLog:(NSMutableDictionary *)serDict;
-(NSMutableArray *)getServiceLogDetails;
-(NSMutableArray *)getCorrespondingServiceLog:(NSString *)strVDId;
-(void)deleteServiceLog:(NSString *)serviceid;
-(void)updateVehicleDetails:(NSMutableDictionary *)dict;
-(void)deleteServiceStation:(NSString *)stationId;
-(void)updateServiceStations:(NSMutableDictionary *)dict;
-(NSMutableArray *)exportVehicleDetailsWithSelectTable:(NSMutableArray *)selectQuery;

@end
