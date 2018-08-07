//
//  ZHJNotificationManager.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/4/28.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIkit.h>

@interface ZHJNotificationManager : NSObject
+ (void)addLocalNotification:(UILocalNotification *)localNotification;
+ (void)cancelLocalNotificationForKey:(NSString *)key;
+ (void)cancelAllLocalNotifications;
@end
