//
//  NSDate+ZHJKit.m
//  ZHJKitDemo
//
//  Created by Kevin Zeng on 2018/8/7.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "NSDate+ZHJKit.h"

@implementation NSDate (ZHJKit)

+ (NSDate *)dateWithFormat:(NSString *)format {
    NSDate *date = [NSDate date];
    NSString *string = [date format:format];
    return [self dateFrom:string format:format];
}
+ (NSDate *)dateFrom:(NSString *)string format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date =[formatter dateFromString:string];
    return date;
}
+ (NSInteger)numOfDaysInYear:(NSInteger)year month:(NSInteger)month {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString * dateString = [NSString stringWithFormat:@"%04ld-%02ld", year, month];
    NSDate * date = [formatter dateFromString:dateString];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate:date];
    return range.length;
}
- (NSString *)format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}
- (NSInteger)year {
    NSInteger year = [[self format:@"yyyy"] integerValue];
    return year;
}
- (NSInteger)month {
    NSInteger month = [[self format:@"MM"] integerValue];
    return month;
}
- (NSInteger)week {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    return theComponents.weekday;
}
- (NSInteger)day {
    NSInteger day = [[self format:@"dd"] integerValue];
    return day;
}
- (NSInteger)hour {
    NSInteger hour = [[self format:@"hh"] integerValue];
    return hour;
}
- (NSInteger)minute {
    NSInteger minute = [[self format:@"mm"] integerValue];
    return minute;
}
- (NSInteger)second {
    NSInteger second = [[self format:@"ss"] integerValue];
    return second;
}
- (NSInteger)intervalSinceDate:(NSDate *)date accuracy:(ZHJDateAccuracy)dateAccuracy {
    int timeInterval = (int)[self timeIntervalSinceDate:date];
    int leftTime = timeInterval;
    int day = (leftTime-leftTime%(24*3600))/(24*3600);
    leftTime = leftTime%(24*3600);
    int hour = (leftTime-leftTime%3600)/3600;
    leftTime = leftTime%3600;
    int minute = (leftTime-leftTime%60)/60;
    leftTime = leftTime%60;
    int second = leftTime;
    switch (dateAccuracy) {
        case ZHJDateAccuracyDay: return day;
        case ZHJDateAccuracyHour: return day*24+hour;
        case ZHJDateAccuracyMinute: return day*24*60+hour*60+minute;
        case ZHJDateAccuracySecond: return day*24*3600+hour*3600+minute*60+second;
        default: return timeInterval;
    }
}
- (NSString *)formatIntervalSinceDate:(NSDate *)date accuracy:(ZHJDateAccuracy)dateAccuracy {
    int timeInterval = (int)[self timeIntervalSinceDate:date];
    int leftTime = timeInterval;
    if (leftTime>0) {
        int day = (leftTime-leftTime%(24*3600))/(24*3600);
        leftTime = leftTime%(24*3600);
        int hour = (leftTime-leftTime%3600)/3600;
        leftTime = leftTime%3600;
        int minute = (leftTime-leftTime%60)/60;
        leftTime = leftTime%60;
        int second = leftTime;
        NSString *dayStr = day>0 ? [NSString stringWithFormat:@"%d天", day] : @"";
        NSString *hourStr = hour>0 ? [NSString stringWithFormat:@"%d小时", hour] : @"";
        NSString *minuteStr = minute>0 ? [NSString stringWithFormat:@"%d分钟", minute] : @"";
        NSString *secondStr = second>0 ? [NSString stringWithFormat:@"%d秒", second] : @"";
        switch (dateAccuracy) {
            case ZHJDateAccuracyDay: return [NSString stringWithFormat:@"%@", dayStr];
            case ZHJDateAccuracyHour: return [NSString stringWithFormat:@"%@%@", dayStr, hourStr];
            case ZHJDateAccuracyMinute: return [NSString stringWithFormat:@"%@%@%@", dayStr, hourStr, minuteStr];
            case ZHJDateAccuracySecond:
            default: return [NSString stringWithFormat:@"%@%@%@%@", dayStr, hourStr, minuteStr, secondStr];
        }
    }else {
        return @"";
    }
}

@end
