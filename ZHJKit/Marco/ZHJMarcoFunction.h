//
//  ZHJMarcoFunction.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#ifndef ZHJMarcoFunction_h
#define ZHJMarcoFunction_h

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define ZHJ_Log(...)                        (printf("\n%s\n", [[NSString stringWithFormat:__VA_ARGS__] UTF8String]))
#define ZHJ_DBLog(fmt, ...)                 (ZHJ_Log((@"\n>>Time: %s\n>>File: %s\n>>Func: %s\n>>Line: %d\n>>Log: \n"fmt@"\n"), [[[NSDate date] description] UTF8String], __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__))
#else
#define ZHJ_Log(...)
#define ZHJ_DBLog(...)
#endif

#define ZHJ_SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define ZHJ_SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define ZHJ_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define ZHJ_SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define ZHJ_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define ZHJ_WEAK_SELF(type)                 __weak typeof(type) weak##type = type
#define ZHJ_STRONG_SELF(type)               __strong typeof(type) type = weak##type

#define ZHJ_GCD_GLOBAL(block)               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define ZHJ_GCD_MAIN(block)                 dispatch_async(dispatch_get_main_queue(),block)

#define ZHJ_VIEW_RADIUS_BORDER(View, CornerRadius, BorderWidth, BorderColor)\
\
[View.layer setCornerRadius:(CornerRadius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(BorderWidth)];\
[View.layer setBorderColor:[BorderColor CGColor]]

#define ZHJ_VIEW(Rect)          ([[UIView alloc] initWithFrame:Rect])
#define ZHJ_LABEL(Rect)         ([[UILabel alloc] initWithFrame:Rect])
#define ZHJ_IMAGEVIEW(Rect)     ([[UIImageView alloc] initWithFrame:Rect])
#define ZHJ_BUTTON(Rect)        ([[UIButton alloc] initWithFrame:Rect])
#define ZHJ_TEXTFIELD(Rect)     ([[UITextField alloc] initWithFrame:Rect])
#define ZHJ_IMAGE(imageName)    ([UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]])

#define ZHJ_HEXCOLOR(rgbValue, alphaValue)  ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue])

#endif /* ZHJMarcoFunction_h */
