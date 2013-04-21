//
//  TimeUtil.m
//  TimeUtilSample
//
//  Created by hiasa on 13/04/21.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import "TimeUtil.h"

#define DAY 60*60*24
#define HOUR 60*60
#define MINUTE 60

@interface TimeUtil(private)
+ (NSDateFormatter *)setDefaultFormatter;
@end

@implementation TimeUtil

+ (NSDateFormatter *)setDefaultFormatter{
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"DateFormatter" ofType:@"plist"];
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    [defaultFormatter setDateFormat:[dictionary objectForKey:@"defaultFormat"]];
    [defaultFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"US"]];
    return defaultFormatter;
}

+ (NSString *)getNowTimeStr{
    NSDate *nowTime = [NSDate date];
    NSDateFormatter *defaultFormatter = [self setDefaultFormatter];
    return [defaultFormatter stringFromDate:nowTime];
}

+ (NSString *)convertDateFormatterToDefault:(NSString *)date dateFormat:(NSString *)dateFormat{
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:dateFormat];
    [inputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"US"]];
    NSDate *inputDate = [inputDateFormatter dateFromString:date];
    
    NSDateFormatter *defaultFormatter = [self setDefaultFormatter];
    NSString *outputDate = [defaultFormatter stringFromDate:inputDate];
    return outputDate;
}

+ (NSString *)getPassTime:(NSString *)startTime{
    NSDateFormatter *defaultFormatter =  [self setDefaultFormatter];
    NSDate *inputDate = [defaultFormatter dateFromString:startTime];
    NSDate *nowTime = [NSDate date];
    NSInteger interval = [nowTime timeIntervalSinceDate:inputDate];
    
    if (interval > DAY) {
        NSInteger day = interval/DAY;
        return [NSString stringWithFormat:@"%d日前", day];
    }else{
        if (interval > HOUR) {
            NSInteger hour = interval/HOUR;
            return [NSString stringWithFormat:@"%d時間前", hour];
        }else if(interval > MINUTE){
            
            NSInteger minite = interval/MINUTE;
            if (minite > 30*MINUTE) {
                return @"30分前";
            }else if (minite > 10*MINUTE) {
                return @"10分前";
            }else if (minite > 5*MINUTE) {
                return @"5分前";
            }else if (minite > 3*MINUTE) {
                return @"3分前";
            }else if (minite > 1*MINUTE) {
                return @"1分前";
            }
            
        }else{
            NSInteger second = interval%MINUTE;
            return [NSString stringWithFormat:@"%d秒前", second];
        }
        
    }
    
    return nil;
}

+ (NSString *)getReminingTime:(NSString *)endTime{
    NSDateFormatter *defaultFormatter =  [self setDefaultFormatter];
    NSDate *inputDate = [defaultFormatter dateFromString:endTime];
    NSInteger interval = [inputDate timeIntervalSinceNow];
    
    NSString *reminingTime = nil;
    if (interval >= 0) {
        
        if (interval > DAY) {
            
            NSInteger hour = interval/DAY;
            return [NSString stringWithFormat:@"%d日後", hour];
        }else{
            
            if (interval > HOUR) {
                NSInteger hour = interval/HOUR;
                reminingTime = [NSString stringWithFormat:@"%02d:", hour];
                interval = interval%HOUR;
            }
            
            if (interval > MINUTE) {
                NSInteger minute = interval/MINUTE;
                reminingTime = [NSString stringWithFormat:@"%@%02d:", reminingTime, minute];
                interval = interval%MINUTE;
            }
            
            reminingTime = [NSString stringWithFormat:@"%@%02d", reminingTime, interval];
            return reminingTime;
        }
    }
    return nil;
}

@end
