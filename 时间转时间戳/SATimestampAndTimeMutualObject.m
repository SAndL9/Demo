//
//  SATimestampAndTimeMutualObject.m
//  Pods
//
//  Created by LiLei on 10/8/17.
//
//

#import "SATimestampAndTimeMutualObject.h"

@implementation SATimestampAndTimeMutualObject


+ (instancetype)shareInstance {
    static SATimestampAndTimeMutualObject* timestampAndTime  = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        timestampAndTime = [[SATimestampAndTimeMutualObject alloc] init];
    }) ;
    return timestampAndTime;
}


/** 时间戳转时间 */
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


/** 时间转时间戳 */
- (NSString *)timeSwitchTimestamp:(NSString *)formatTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime];
    
    //时间转时间戳的方法:
    NSString *timestamp = [NSString stringWithFormat:@"%ld",[[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue]  * 1000];
    
    return timestamp;
    
}



@end
