//
//  TimeUtil.h
//  TimeUtilSample
//
//  Created by hiasa on 13/04/21.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject

+ (NSString *)getNowTimeStr;
+ (NSString *)convertDateFormatterToDefault:(NSString *)date dateFormat:(NSString *)dateFormat;
+ (NSString *)getPassTime:(NSString *)startTime;
+ (NSString *)getReminingTime:(NSString *)endTime;

@end
