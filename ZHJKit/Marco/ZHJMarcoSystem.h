//
//  ZHJMarcoSystem.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#ifndef ZHJMarcoSystem_h
#define ZHJMarcoSystem_h

#import <UIKit/UIKit.h>

#define ZHJ_APP                     ([UIApplication sharedApplication])
#define ZHJ_APP_DELEGATE            ([UIApplication sharedApplication])
#define ZHJ_KEY_WINDOW              ([UIApplication sharedApplication].keyWindow)
#define ZHJ_USER_DEFAULTS           ([NSUserDefaults standardUserDefaults])
#define ZHJ_NOTIFICATION_CENTER     ([NSNotificationCenter defaultCenter])
#define ZHJ_BUNDLE                          ([NSBundle mainBundle])

#define ZHJ_SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.width)
#define ZHJ_SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height)
#define ZHJ_SCREEN_SIZE             ([UIScreen mainScreen].bounds.size)
#define ZHJ_SCALE                   ([UIScreen mainScreen].bounds.size.width/375.0)
#define ZHJ_IS_IPHONEX              ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height==2436 : NO)
#define ZHJ_STATUSBAR_HEIGHT        (ZHJ_IS_IPHONEX ? 44 : 20)
#define ZHJ_NAVBAR_HEIGHT           (ZHJ_IS_IPHONEX ? 88 : 64)
#define ZHJ_TABBAR_HEIGHT           (ZHJ_IS_IPHONEX ? 83 : 49)

#define ZHJ_DOCUMENT_PATH           ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject])
#define ZHJ_CACHE_PATH              ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject])
#define ZHJ_TEMP_PATH               (NSTemporaryDirectory())

#define ZHJ_SYSTEM_VERSION          ([[UIDevice currentDevice] systemVersion])
#define ZHJ_APP_VERSION             ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#endif /* ZHJMarcoSystem_h */
