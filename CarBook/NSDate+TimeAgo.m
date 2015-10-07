#import "NSDate+TimeAgo.h"

@implementation NSDate (TimeAgo)

-(NSString *)daysCalculate {
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    return [NSString stringWithFormat:@"%d", (int)floor(deltaMinutes/(60 * 24))];
}

-(NSString *)calculateNSDate:(NSString *)nextdate {
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"dd/MMM/yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [format dateFromString:nextdate];
    NSTimeInterval timeInterval = [dateFromString timeIntervalSince1970];
    NSDate *callDate = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
    return [callDate daysCalculate];
}

@end
