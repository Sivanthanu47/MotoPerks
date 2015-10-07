//
//  VTFMDataBase.m
//  DMRecognizer
//
//  Created by Raja Sekhar on 10/03/14.
//
//

#import "CBDBMethods.h"
#import "CHCSVParser.h"
@implementation CBDBMethods {
    
}
@synthesize arrgetCarData;
+ (id)sharedTools {
    static CBDBMethods *sharedTools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTools = [[self alloc] init];
    });
    return sharedTools;
}

- (id)init{
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    arrgetCarData = [[NSMutableArray alloc] init];
    return self;
}

#pragma mark - InsertDataBaseFunction

-(void)insertVehicles:(NSMutableDictionary *)carDetails {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"insert into tblVehicleDetails(VDId,CarName,InsuranceDate,RegisterDate,FuelType,CMRead,Owner,Address,FirstService,ServiceMonthInterval,ServiceKmInterval,LSDate,Sellername,ownerAddr,Note,PhotoURL) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[carDetails objectForKey:@"VDId"],[carDetails objectForKey:@"CarName"],[carDetails objectForKey:@"InsuranceDate"],[carDetails objectForKey:@"RegisterDate"],[carDetails objectForKey:@"FuelType"],[carDetails objectForKey:@"CMRead"],[carDetails objectForKey:@"Owner"],[carDetails objectForKey:@"Address"],[carDetails objectForKey:@"FirstService"],[carDetails objectForKey:@"ServiceMonthInterval"],[carDetails objectForKey:@"ServiceKmInterval"],[carDetails objectForKey:@"LastServiceDate"],[carDetails objectForKey:@"Sellername"],[carDetails objectForKey:@"ownerAddr"],[carDetails objectForKey:@"Note"],[carDetails objectForKey:@"PhotoURL"],nil];
    [database close];
}

-(void)insertServiceDetails:(NSMutableDictionary *)dict {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"insert into tblServiceStation(StationName,AddCity,Address,PhoneNo,ContactNo,Notes,Latitude,Longitude), values (?,?,?,?,?,?,?,?)",[dict objectForKey:@"stationName"],[dict objectForKey:@"AddCity"],[dict objectForKey:@"Address"],[dict objectForKey:@"PhoneNo"],[dict objectForKey:@"ContactNo"],[dict objectForKey:@"Notes"],[dict objectForKey:@"Latitude"],[dict objectForKey
                                                                                                                                                                                                                                                                                                                                                                                              :@"Longitude"],nil];
        [database close];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddedService" object:nil];
}

-(void)inserTrackDetails:(NSMutableDictionary *)trackDetail {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"insert into tblTrackMileage(rate,Quantity,fuelCost,CMRead,CarName,StationName,Date) values (?,?,?,?,?,?,?)",[trackDetail objectForKey:@"Rate"],[trackDetail objectForKey:@"Quantity"],[trackDetail objectForKey:@"fuelCost"],[trackDetail objectForKey:@"CMRead"],[trackDetail objectForKey:@"CarName"],[trackDetail objectForKey:@"StationName"],[trackDetail objectForKey:@"TrackDate"],nil];
    [database close];
}

-(void)insertNotification:(NSMutableDictionary *)notifi {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"insert into tblNotification(CarName,StationName,Date,TravelKM,ServiceInterval,VDId,SSId) values (?,?,?,?,?,?,?)",[notifi objectForKey:@"CarName"],[notifi objectForKey:@"StationName"],[notifi objectForKey:@"NextServiceDate"],[notifi objectForKey:@"TravelKM"],[notifi objectForKey:@"ServiceInterval"],[notifi objectForKey:@"VDId"],[notifi objectForKey:@"SSId"],nil];
    [database close];
}

-(void)inserServiceLog:(NSMutableDictionary *)serDict {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"insert into tblServiceDetails(CarName,StationName,Date,Cost,TypeOfService,Notes,VDId,SSId) values (?,?,?,?,?,?,?,?)",[serDict objectForKey:@"CarName"],[serDict objectForKey:@"StationName"],[serDict objectForKey:@"Date"],[serDict objectForKey:@"Cost"],[serDict objectForKey:@"TypeOfService"],[serDict objectForKey:@"Note"],[serDict objectForKey:@"VDId"],[serDict objectForKey:@"SSId"],nil];
    [database close];
}

#pragma mark - SelectDataBaseFunction

-(NSMutableArray *)getVehicleDetails {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblVehicleDetails"];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString * vehicleId = [results stringForColumn:@"VDId"];
        [dictionary setObject:vehicleId forKey:@"VDId"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
               NSString *insurDate = [results stringForColumn:@"InsuranceDate"];
        [dictionary setObject:insurDate forKey:@"InsuranceDate"];
        NSString *purdate = [results stringForColumn:@"RegisterDate"];
        [dictionary setObject:purdate forKey:@"RegisterDate"];
       NSString *fueltype = [results stringForColumn:@"FuelType"];
        [dictionary setObject:fueltype forKey:@"FuelType"];
        NSString *cmread = [results stringForColumn:@"CMRead"];
        [dictionary setObject:cmread forKey:@"CMRead"];
        NSString *owner = [results stringForColumn:@"Owner"];
        [dictionary setObject:owner forKey:@"Owner"];
       NSString *addr = [results stringForColumn:@"Address"];
        [dictionary setObject:addr forKey:@"Address"];
        NSString *firstservice = [results stringForColumn:@"FirstService"];
        [dictionary setObject:firstservice forKey:@"FirstService"];
       NSString *service = [results stringForColumn:@"ServiceMonthInterval"];
        [dictionary setObject:service forKey:@"ServiceMonthInterval"];
        NSString *serinter = [results stringForColumn:@"ServiceKmInterval"];
        [dictionary setObject:serinter forKey:@"ServiceKmInterval"];
        NSString *lsdate = [results stringForColumn:@"LSDate"];
        [dictionary setObject:lsdate forKey:@"LastServiceDate"];
        NSString *Sell = [results stringForColumn:@"Sellername"];
        [dictionary setObject:Sell forKey:@"Sellername"];
        NSString *owneraddr = [results stringForColumn:@"ownerAddr"];
        [dictionary setObject:owneraddr forKey:@"ownerAddr"];
        NSString *note = [results stringForColumn:@"Note"];
        [dictionary setObject:note forKey:@"Note"];
        NSString *photourl = [results stringForColumn:@"PhotoURL"];
        [dictionary setObject:photourl forKey:@"PhotoURL"];
        [arrgetCarData addObject:dictionary];
        NSLog(@"%@",arrgetCarData);
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)getSingleVehicleDetail:(NSString *)vehicleID {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblVehicleDetails WHERE VDId = ?",vehicleID];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString * vehicleId = [results stringForColumn:@"VDId"];
        [dictionary setObject:vehicleId forKey:@"VDId"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *insurDate = [results stringForColumn:@"InsuranceDate"];
        [dictionary setObject:insurDate forKey:@"InsuranceDate"];
        NSString *purdate = [results stringForColumn:@"RegisterDate"];
        [dictionary setObject:purdate forKey:@"RegisterDate"];
        NSString *fueltype = [results stringForColumn:@"FuelType"];
        [dictionary setObject:fueltype forKey:@"FuelType"];
        NSString *cmread = [results stringForColumn:@"CMRead"];
        [dictionary setObject:cmread forKey:@"CMRead"];
        NSString *owner = [results stringForColumn:@"Owner"];
        [dictionary setObject:owner forKey:@"Owner"];
        NSString *addr = [results stringForColumn:@"Address"];
        [dictionary setObject:addr forKey:@"Address"];
        NSString *firstservice = [results stringForColumn:@"FirstService"];
        [dictionary setObject:firstservice forKey:@"FirstService"];
        NSString *service = [results stringForColumn:@"ServiceMonthInterval"];
        [dictionary setObject:service forKey:@"ServiceMonthInterval"];
        NSString *serinter = [results stringForColumn:@"ServiceKmInterval"];
        [dictionary setObject:serinter forKey:@"ServiceKmInterval"];
        NSString *lsdate = [results stringForColumn:@"LSDate"];
        [dictionary setObject:lsdate forKey:@"LastServiceDate"];
        NSString *Sell = [results stringForColumn:@"Sellername"];
        [dictionary setObject:Sell forKey:@"Sellername"];
        NSString *owneraddr = [results stringForColumn:@"ownerAddr"];
        [dictionary setObject:owneraddr forKey:@"ownerAddr"];
        NSString *note = [results stringForColumn:@"Note"];
        [dictionary setObject:note forKey:@"Note"];
        NSString *photourl = [results stringForColumn:@"PhotoURL"];
        [dictionary setObject:photourl forKey:@"PhotoURL"];
        [arrgetCarData addObject:dictionary];

        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}
-(NSMutableArray *)getServiceStationVehicleLogs:(NSString *)VINID {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblVehicleDetails WHERE VIN = ?",VINID];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *carid = [results stringForColumn:@"VDId"];
        [dictionary setObject:carid forKey:@"VDId"];
        NSString *ssid = [results stringForColumn:@"SSId"];
        [dictionary setObject:ssid forKey:@"SSId"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *note = [results stringForColumn:@"Note"];
        [dictionary setObject:note forKey:@"Note"];
        NSString *vin = [results stringForColumn:@"VIN"];
        [dictionary setObject:vin forKey:@"VIN"];
        NSString *insurance = [results stringForColumn:@"InsuranceName"];
        [dictionary setObject:insurance forKey:@"InsuranceName"];
        NSString *insurDate = [results stringForColumn:@"InsuranceDate"];
        [dictionary setObject:insurDate forKey:@"InsuranceDate"];
        NSString *lsdate = [results stringForColumn:@"LSDate"];
        [dictionary setObject:lsdate forKey:@"LastServiceDate"];
        NSString *nsdate = [results stringForColumn:@"NSDate"];
        [dictionary setObject:nsdate forKey:@"NextServiceDate"];
        NSString *purdate = [results stringForColumn:@"RegisterDate"];
        [dictionary setObject:purdate forKey:@"RegisterDate"];
        NSString *owner = [results stringForColumn:@"Owner"];
        [dictionary setObject:owner forKey:@"Owner"];
        NSString *choser = [results stringForColumn:@"StationName"];
        [dictionary setObject:choser forKey:@"StationName"];
        NSString *serinter = [results stringForColumn:@"ServiceInterval"];
        [dictionary setObject:serinter forKey:@"ServiceInterval"];
        NSString *kilomet = [results stringForColumn:@"TravelKM"];
        [dictionary setObject:kilomet forKey:@"TravelKM"];
        NSString *fuel = [results stringForColumn:@"Fuel"];
        [dictionary setObject:fuel forKey:@"Fuel"];
        NSString *fueltype = [results stringForColumn:@"FuelType"];
        [dictionary setObject:fueltype forKey:@"FuelType"];
        NSString *cmread = [results stringForColumn:@"CMRead"];
        [dictionary setObject:cmread forKey:@"CMRead"];
        NSString *photourl = [results stringForColumn:@"PhotoURL"];
        [dictionary setObject:photourl forKey:@"PhotoURL"];
        NSString *lic = [results stringForColumn:@"License"];
        [dictionary setObject:lic forKey:@"License"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)exportVehicleDetailsWithSelectTable:(NSMutableArray *)ArrQuery {
    NSMutableArray * arrCsvPath =[[NSMutableArray alloc]init];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    for (NSString *selectQury in ArrQuery) {
        FMResultSet *results = [database executeQuery:selectQury];
        NSString *csvPath = [_appDelegate.docsPath stringByAppendingPathComponent:@"ExportFile.csv"];
        CHCSVWriter *csvWriter = [[CHCSVWriter alloc] initForWritingToCSVFile:csvPath];
        [arrCsvPath addObject:csvPath];
        while([results next]) {
            NSDictionary *resultRow = [results resultDict];
            NSArray *orderedKeys = [[resultRow allKeys] sortedArrayUsingSelector:@selector(compare:)];
            for (NSString *columnName in orderedKeys) {
                id value = [resultRow objectForKey:columnName];
                [csvWriter writeField:value];
            }
            [csvWriter finishLine];
        }
        [csvWriter closeStream];
        [database close];
    }
    NSLog(@"selectQuery %@",arrCsvPath);
    return arrCsvPath;
    
}

-(NSMutableArray *)getSingleStationwithVehicle:(NSString *)stationID {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblVehicleDetails WHERE SSId = ?",stationID];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *carid = [results stringForColumn:@"VDId"];
        [dictionary setObject:carid forKey:@"VDId"];
        NSString *ssid = [results stringForColumn:@"SSId"];
        [dictionary setObject:ssid forKey:@"SSId"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *lsdate = [results stringForColumn:@"LSDate"];
        [dictionary setObject:lsdate forKey:@"LastServiceDate"];
        NSString *photourl = [results stringForColumn:@"PhotoURL"];
        [dictionary setObject:photourl forKey:@"PhotoURL"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}
-(NSMutableArray *)getSingleServicewithMileage:(NSString *)stationID {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblTrackMileage WHERE TMId = ?",stationID];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *ssid = [results stringForColumn:@"TMId"];
        [dictionary setObject:ssid forKey:@"TMId"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *note = [results stringForColumn:@"StationName"];
        [dictionary setObject:note forKey:@"stationName"];
        NSString *vin = [results stringForColumn:@"Date"];
        [dictionary setObject:vin forKey:@"TrackDate"];
        NSString *cmread = [results stringForColumn:@"CMRead"];
        [dictionary setObject:cmread forKey:@"CMRead"];
        NSString *carid = [results stringForColumn:@"VDId"];
        [dictionary setObject:carid forKey:@"VDId"];
        NSString *rate = [results stringForColumn:@"Rate"];
        [dictionary setObject:rate forKey:@"Rate"];
        NSString *quantity = [results stringForColumn:@"Quantity"];
        [dictionary setObject:quantity forKey:@"Quantity"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)getServiceStationDetails {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblServiceStation order by SSId Desc"];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *ssid = [results stringForColumn:@"SSId"];
        [dictionary setObject:ssid forKey:@"SSId"];
        NSString *stationname = [results stringForColumn:@"StationName"];
        [dictionary setObject:stationname forKey:@"stationName"];
        NSString *addcity = [results stringForColumn:@"AddCity"];
        [dictionary setObject:addcity forKey:@"AddCity"];
        NSString *Address = [results stringForColumn:@"Address"];
        [dictionary setObject:Address forKey:@"Address"];
        NSString *phoneno = [results stringForColumn:@"PhoneNo"];
        [dictionary setObject:phoneno forKey:@"PhoneNo"];
        NSString *ContactNo = [results stringForColumn:@"ContactNo"];
        [dictionary setObject:ContactNo forKey:@"ContactNo"];
        NSString *Notes = [results stringForColumn:@"Notes"];
        [dictionary setObject:Notes forKey:@"Notes"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)getStationWithMap:(NSString *)stationID {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblServiceStation WHERE SSId = ?",stationID];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *stationname = [results stringForColumn:@"StationName"];
        [dictionary setObject:stationname forKey:@"stationName"];
        NSString *addcity = [results stringForColumn:@"AddCity"];
        [dictionary setObject:addcity forKey:@"AddCity"];
        NSString *Address = [results stringForColumn:@"Address"];
        [dictionary setObject:Address forKey:@"Address"];
        NSString *phoneno = [results stringForColumn:@"PhoneNo"];
        [dictionary setObject:phoneno forKey:@"PhoneNo"];
        NSString *email = [results stringForColumn:@"ContactNo"];
        [dictionary setObject:email forKey:@"ContactNo"];
        NSString *lat = [results stringForColumn:@"Latitude"];
        [dictionary setObject:lat forKey:@"Latitude"];
        NSString *longti = [results stringForColumn:@"Longitude"];
        [dictionary setObject:longti forKey:@"Longitude"];
        NSString *Notes = [results stringForColumn:@"Notes"];
        [dictionary setObject:Notes forKey:@"Notes"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)getTracksDetail {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblTrackMileage"];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *trackid = [results stringForColumn:@"TMId"];
        [dictionary setObject:trackid forKey:@"TMId"];
        NSString *rate = [results stringForColumn:@"Rate"];
        [dictionary setObject:rate forKey:@"Rate"];
        NSString *quantity = [results stringForColumn:@"Quantity"];
        [dictionary setObject:quantity forKey:@"Quantity"];
        NSString *cost = [results stringForColumn:@"fuelCost"];
        [dictionary setObject:cost forKey:@"fuelCost"];
        NSString *cmread = [results stringForColumn:@"CMRead"];
        [dictionary setObject:cmread forKey:@"CMRead"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *note = [results stringForColumn:@"StationName"];
        [dictionary setObject:note forKey:@"stationName"];
       NSString *vin = [results stringForColumn:@"Date"];
        [dictionary setObject:vin forKey:@"TrackDate"];
        [arrgetCarData addObject:dictionary];
        NSLog(@"dictionary %@",arrgetCarData);
    }
    [database close];
    return arrgetCarData;
}
-(NSMutableArray *)getCorrespondingTrackID:(NSString *)trackID WithVehicle:(NSString *)vecID {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results;
    if (trackID == nil) {
        results = [database executeQuery:@"select * from tblTrackMileage WHERE VDId = ?",vecID];
    } else {
        results = [database executeQuery:@"select * from tblTrackMileage WHERE TMId = ?",trackID];
    }
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *trackid = [results stringForColumn:@"TMId"];
        [dictionary setObject:trackid forKey:@"TMId"];
            NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *note = [results stringForColumn:@"StationName"];
        [dictionary setObject:note forKey:@"stationName"];
        NSString *vin = [results stringForColumn:@"Date"];
        [dictionary setObject:vin forKey:@"TrackDate"];
        NSString *cmread = [results stringForColumn:@"CMRead"];
        [dictionary setObject:cmread forKey:@"CMRead"];
       
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)getNotificationDetail:(NSString *)strId {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results;
    if (strId == nil) {
        results = [database executeQuery:@"select * from tblNotification"];
    } else {
        results = [database executeQuery:@"select * from tblNotification WHERE VDId = ?",strId];
    }
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *notid = [results stringForColumn:@"NFId"];
        [dictionary setObject:notid forKey:@"NFId"];
        //NSString *carid = [results stringForColumn:@"VDId"];
        //[dictionary setObject:carid forKey:@"VDId"];
        //NSString *ssid = [results stringForColumn:@"SSId"];
        //[dictionary setObject:ssid forKey:@"SSId"];
        //NSString *stname = [results stringForColumn:@"StationName"];
        //[dictionary setObject:stname forKey:@"stationName"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *date = [results stringForColumn:@"Date"];
        [dictionary setObject:date forKey:@"NextServiceDate"];
       // NSString *travel = [results stringForColumn:@"TravelKM"];
       //[dictionary setObject:travel forKey:@"TravelKM"];
        //NSString *serinter = [results stringForColumn:@"ServiceInterval"];
        //[dictionary setObject:serinter forKey:@"ServiceInterval"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)getServiceLogDetails {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblServiceDetails"];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *sdid = [results stringForColumn:@"SDId"];
        [dictionary setObject:sdid forKey:@"SDId"];
        NSString *stname = [results stringForColumn:@"StationName"];
        [dictionary setObject:stname forKey:@"stationName"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *date = [results stringForColumn:@"Date"];
        [dictionary setObject:date forKey:@"Date"];
        NSString *cost = [results stringForColumn:@"Cost"];
        [dictionary setObject:cost forKey:@"Cost"];
        NSString *typeOfser = [results stringForColumn:@"TypeOfService"];
        [dictionary setObject:typeOfser forKey:@"TypeOfService"];
        NSString *note = [results stringForColumn:@"Notes"];
        [dictionary setObject:note forKey:@"Note"];
        NSString *vdid = [results stringForColumn:@"VDId"];
        [dictionary setObject:vdid forKey:@"VDId"];
        NSString *ssid = [results stringForColumn:@"SSId"];
        [dictionary setObject:ssid forKey:@"SSId"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)getCorrespondingServiceLog:(NSString *)strVDId {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblServiceDetails WHERE VDId = ? order by SDId Desc",strVDId];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *sdid = [results stringForColumn:@"SDId"];
        [dictionary setObject:sdid forKey:@"SDId"];
        NSString *stname = [results stringForColumn:@"StationName"];
        [dictionary setObject:stname forKey:@"stationName"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *date = [results stringForColumn:@"Date"];
        [dictionary setObject:date forKey:@"Date"];
        NSString *cost = [results stringForColumn:@"Cost"];
        [dictionary setObject:cost forKey:@"Cost"];
        NSString *typeOfser = [results stringForColumn:@"TypeOfService"];
        [dictionary setObject:typeOfser forKey:@"TypeOfService"];
        NSString *note = [results stringForColumn:@"Notes"];
        [dictionary setObject:note forKey:@"Note"];
        NSString *vdid = [results stringForColumn:@"VDId"];
        [dictionary setObject:vdid forKey:@"VDId"];
        NSString *ssid = [results stringForColumn:@"SSId"];
        [dictionary setObject:ssid forKey:@"SSId"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)getCMReadingCount:(NSString *)vid {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select distinct max(TMId) as LastValue, CMRead , NewFuel,TravelKM from tblTrackMileage WHERE VDId = ?",vid];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *cmread = [results stringForColumn:@"CMRead"];
        if (cmread != nil) {
            [dictionary setObject:cmread forKey:@"CMRead"];
        }
        NSString *fuel = [results stringForColumn:@"NewFuel"];
        if (fuel != nil) {
            [dictionary setObject:fuel forKey:@"NewFuel"];
        }
        NSString * kilometer = [results stringForColumn:@"TravelKM"];
        if (kilometer!=nil) {
            [dictionary setObject:kilometer forKey:@"TravelKM"];
        }
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

#pragma mark - DeleteDataBaseFunction

-(void)deleteVehicle:(NSString *)VDid {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"DELETE FROM tblVehicleDetails WHERE VDId = ?", VDid];
    [database executeUpdate:@"DELETE FROM tblTrackMileage WHERE VDId = ?", VDid];
    [database executeUpdate:@"DELETE FROM tblServiceDetails WHERE VDId = ?", VDid];
    [database executeUpdate:@"DELETE FROM tblNotification WHERE VDId = ?", VDid];
    [database close];
}

-(void)deleteTrackMileage:(NSString *)Trackid {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"DELETE FROM tblTrackMileage WHERE TMId = ?", Trackid];
    [database close];
}

-(void)deleteNotification:(NSString *)notiid {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"DELETE FROM tblNotification WHERE NFId = ?", notiid];
    [database close];
}

-(void)deleteServiceLog:(NSString *)serviceid {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"DELETE FROM tblServiceDetails WHERE SDId = ?", serviceid];
    [database close];
}

-(void)deleteServiceStation:(NSString *)stationId {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"DELETE FROM tblVehicleDetails WHERE SSId = ?", stationId];
    [database executeUpdate:@"DELETE FROM tblServiceDetails WHERE SDId = ?", stationId];
    [database executeUpdate:@"DELETE FROM tblNotification WHERE SSId = ?", stationId];
    [database executeUpdate:@"DELETE FROM tblServiceStation WHERE SSId = ?", stationId];
    [database close];
}

#pragma mark - UpdateDataBaseFunction

-(void)updateLocalNotification:(NSMutableDictionary *)dict  {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"UPDATE tblNotification set Date = ? WHERE VDId = ?",[dict objectForKey:@"NextServiceDate"],[dict objectForKey:@"VDId"]];
    [database executeUpdate:@"UPDATE tblVehicleDetails set LSDate = ?, NSDate = ? WHERE VDId = ?",[dict objectForKey:@"Date"],[dict objectForKey:@"NextServiceDate"],[dict objectForKey:@"VDId"]];
    [database close];
}

-(void)updateVehicleDetails:(NSMutableDictionary *)dict  {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"UPDATE tblVehicleDetails set CarName = ?, Note = ?, VIN = ?, InsuranceName = ?, InsuranceDate = ?, License = ?, LSDate = ?, NSDate = ?, RegisterDate = ?, Owner = ?, ServiceInterval = ?, CMRead = ?, StationName = ?, TravelKM = ?,Fuel = ?,FuelType = ?, PhotoURL = ?, SSId = ? WHERE VDId = ?",[dict objectForKey:@"CarName"],[dict objectForKey:@"Note"],[dict objectForKey:@"VIN"],[dict objectForKey:@"InsuranceName"],[dict objectForKey:@"InsuranceDate"],[dict objectForKey:@"License"],[dict objectForKey:@"LastServiceDate"],[dict objectForKey:@"NextServiceDate"],[dict objectForKey:@"RegisterDate"],[dict objectForKey:@"Owner"],[dict objectForKey:@"ServiceInterval"],[dict objectForKey:@"CMRead"],[dict objectForKey:@"StationName"],[dict objectForKey:@"TravelKM"],[dict objectForKey:@"Fuel"],[dict objectForKey:@"FuelType"],[dict objectForKey:@"PhotoURL"],[dict objectForKey:@"SSId"],[dict objectForKey:@"VDId"]];
    [database executeUpdate:@"UPDATE tblNotification set Date = ? WHERE VDId = ?",[dict objectForKey:@"NextServiceDate"],[dict objectForKey:@"VDId"]];
    [database close];
}

-(void)updateServiceStations:(NSMutableDictionary *)dict  {
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    [database executeUpdate:@"UPDATE tblServiceStation set StationName = ?, AddPlace = ?, AddCity = ?, PhoneNo = ?, Email = ?, LocationMap = ?, Latitude = ?, Longitude = ? WHERE SSId = ?",[dict objectForKey:@"stationName"],[dict objectForKey:@"AddPlace"],[dict objectForKey:@"AddCity"],[dict objectForKey:@"PhoneNo"],[dict objectForKey:@"Email"],[dict objectForKey:@"LocationMap"],[dict objectForKey:@"Latitude"],[dict objectForKey:@"Longitude"],[dict objectForKey:@"SSId"]];
    [database close];
}

#pragma mark - SearchingDataBaseFunction

-(NSMutableArray *)searchingVehicleName:(NSString *)search {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblVehicleDetails WHERE CarName like ? or StationName like ? or InsuranceDate like ? or InsuranceName like ? or RegisterDate like ? or Owner like ? or Fuel like ? or FuelType like ? or License like ? or VIN like ? or LSDate like ?",[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search]];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *carid = [results stringForColumn:@"VDId"];
        [dictionary setObject:carid forKey:@"VDId"];
        NSString *ssid = [results stringForColumn:@"SSId"];
        [dictionary setObject:ssid forKey:@"SSId"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *note = [results stringForColumn:@"Note"];
        [dictionary setObject:note forKey:@"Note"];
        NSString *vin = [results stringForColumn:@"VIN"];
        [dictionary setObject:vin forKey:@"VIN"];
        NSString *insurance = [results stringForColumn:@"InsuranceName"];
        [dictionary setObject:insurance forKey:@"InsuranceName"];
        NSString *insurDate = [results stringForColumn:@"InsuranceDate"];
        [dictionary setObject:insurDate forKey:@"InsuranceDate"];
        NSString *lsdate = [results stringForColumn:@"LSDate"];
        [dictionary setObject:lsdate forKey:@"LastServiceDate"];
        NSString *nsdate = [results stringForColumn:@"NSDate"];
        [dictionary setObject:nsdate forKey:@"NextServiceDate"];
        NSString *purdate = [results stringForColumn:@"RegisterDate"];
        [dictionary setObject:purdate forKey:@"RegisterDate"];
        NSString *owner = [results stringForColumn:@"Owner"];
        [dictionary setObject:owner forKey:@"Owner"];
        NSString *choser = [results stringForColumn:@"StationName"];
        [dictionary setObject:choser forKey:@"StationName"];
        NSString *serinter = [results stringForColumn:@"ServiceInterval"];
        [dictionary setObject:serinter forKey:@"ServiceInterval"];
        NSString *kilomet = [results stringForColumn:@"TravelKM"];
        [dictionary setObject:kilomet forKey:@"TravelKM"];
        NSString *fuel = [results stringForColumn:@"Fuel"];
        [dictionary setObject:fuel forKey:@"Fuel"];
        NSString *fueltype = [results stringForColumn:@"FuelType"];
        [dictionary setObject:fueltype forKey:@"FuelType"];
        NSString *cmread = [results stringForColumn:@"CMRead"];
        [dictionary setObject:cmread forKey:@"CMRead"];
        NSString *photourl = [results stringForColumn:@"PhotoURL"];
        [dictionary setObject:photourl forKey:@"PhotoURL"];
        NSString *lic = [results stringForColumn:@"License"];
        [dictionary setObject:lic forKey:@"License"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)searchingServiceStationName:(NSString *)search {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblServiceStation WHERE StationName like ? or AddPlace like ? or AddCity like ? or PhoneNo like ? or Email like ?",[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search]];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *ssid = [results stringForColumn:@"SSId"];
        [dictionary setObject:ssid forKey:@"SSId"];
        NSString *stationname = [results stringForColumn:@"StationName"];
        [dictionary setObject:stationname forKey:@"stationName"];
        NSString *addplace = [results stringForColumn:@"AddPlace"];
        [dictionary setObject:addplace forKey:@"AddPlace"];
        NSString *addcity = [results stringForColumn:@"AddCity"];
        [dictionary setObject:addcity forKey:@"AddCity"];
        NSString *phoneno = [results stringForColumn:@"PhoneNo"];
        [dictionary setObject:phoneno forKey:@"PhoneNo"];
        NSString *email = [results stringForColumn:@"Email"];
        [dictionary setObject:email forKey:@"Email"];
        NSString *map = [results stringForColumn:@"LocationMap"];
        [dictionary setObject:map forKey:@"LocationMap"];
        NSString *lat = [results stringForColumn:@"Latitude"];
        [dictionary setObject:lat forKey:@"Latitude"];
        NSString *longti = [results stringForColumn:@"Longitude"];
        [dictionary setObject:longti forKey:@"Longitude"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

-(NSMutableArray *)searchingTrackMileageName:(NSString *)search {
    [arrgetCarData removeAllObjects];
    _appDelegate.mainPaths = [[Constants sharedPath] getDocumentPath];
    _appDelegate.docsPath = [_appDelegate.mainPaths objectAtIndex:0];
    _appDelegate.db_path = [_appDelegate.docsPath stringByAppendingPathComponent:DB_NAME];
    database = [FMDatabase databaseWithPath:_appDelegate.db_path];
    [database open];
    FMResultSet *results = [database executeQuery:@"select * from tblTrackMileage WHERE CarName like ? or StationName like ? or NewFuel like ? or FuelType like ? or Date like ?",[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search],[NSString stringWithFormat:@"%%%@%%",search]];
    while ([results next]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSString *trackid = [results stringForColumn:@"TMId"];
        [dictionary setObject:trackid forKey:@"TMId"];
        NSString *carid = [results stringForColumn:@"VDId"];
        [dictionary setObject:carid forKey:@"VDId"];
        NSString *carname = [results stringForColumn:@"CarName"];
        [dictionary setObject:carname forKey:@"CarName"];
        NSString *note = [results stringForColumn:@"StationName"];
        [dictionary setObject:note forKey:@"stationName"];
        NSString *vin = [results stringForColumn:@"Date"];
        [dictionary setObject:vin forKey:@"TrackDate"];
        NSString *insurance = [results stringForColumn:@"KM"];
        [dictionary setObject:insurance forKey:@"TrackKM"];
        NSString *kilomet = [results stringForColumn:@"TravelKM"];
        [dictionary setObject:kilomet forKey:@"TravelKM"];
        NSString *nfuel = [results stringForColumn:@"NewFuel"];
        [dictionary setObject:nfuel forKey:@"NewFuel"];
        NSString *oldfuel = [results stringForColumn:@"OldFuel"];
        [dictionary setObject:oldfuel forKey:@"OldFuel"];
        NSString *fueltype = [results stringForColumn:@"FuelType"];
        [dictionary setObject:fueltype forKey:@"FuelType"];
        NSString *cmread = [results stringForColumn:@"CMRead"];
        [dictionary setObject:cmread forKey:@"CMRead"];
        NSString *photourl = [results stringForColumn:@"PhotoURL"];
        [dictionary setObject:photourl forKey:@"PhotoURL"];
        [arrgetCarData addObject:dictionary];
    }
    [database close];
    return arrgetCarData;
}

@end
