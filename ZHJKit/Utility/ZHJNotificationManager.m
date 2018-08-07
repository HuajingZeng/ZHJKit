//
//  ZHJNotificationManager.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/4/28.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "ZHJNotificationManager.h"

@implementation ZHJNotificationManager

+ (void)addLocalNotification:(UILocalNotification *)localNotification {
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+ (void)cancelLocalNotificationForKey:(NSString *)key {
    for (UILocalNotification *obj in [UIApplication sharedApplication].scheduledLocalNotifications) {
        if ([obj.userInfo.allKeys containsObject:key]) {
            [[UIApplication sharedApplication] cancelLocalNotification:obj];
        }
    }
}

+ (void)cancelAllLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
