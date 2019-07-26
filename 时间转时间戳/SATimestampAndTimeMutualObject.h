//
//  SATimestampAndTimeMutualObject.h
//  Pods
//
//  Created by LiLei on 10/8/17.
//
//时间戳、时间转换

#import <Foundation/Foundation.h>

@interface SATimestampAndTimeMutualObject : NSObject


+ (instancetype)shareInstance;

/**
 时间戳 --> 时间
 
 @param timeString  时间戳<单位 毫秒>
 @return 时间 <格式 YYYY-MM-dd HH:mm:ss>
 */
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString;



/**
 时间 --> 时间戳
 
 @param formatTime 时间 <格式 YYYY-MM-dd HH:mm:ss>
 @return 时间戳 <单位是 毫秒>
 */
- (NSString *)timeSwitchTimestamp:(NSString *)formatTime;


@end
