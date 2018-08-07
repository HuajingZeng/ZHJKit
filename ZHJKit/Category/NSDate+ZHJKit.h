//
//  NSDate+ZHJKit.h
//  ZHJKitDemo
//
//  Created by Kevin Zeng on 2018/8/7.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZHJDateAccuracy) {
    ZHJDateAccuracyDay = 0,
    ZHJDateAccuracyHour = 1,
    ZHJDateAccuracyMinute = 2,
    ZHJDateAccuracySecond = 3,
};

@interface NSDate (ZHJKit)

+ (NSDate *)dateWithFormat:(NSString *)format;
+ (NSDate *)dateFrom:(NSString *)string format:(NSString *)format;
+ (NSInteger)numOfDaysInYear:(NSInteger)year month:(NSInteger)month;
- (NSString *)format:(NSString *)format;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)week;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSInteger)intervalSinceDate:(NSDate *)endDate accuracy:(ZHJDateAccuracy)dateAccuracy;
- (NSString *)formatIntervalSinceDate:(NSDate *)endDate accuracy:(ZHJDateAccuracy)dateAccuracy;

@end
