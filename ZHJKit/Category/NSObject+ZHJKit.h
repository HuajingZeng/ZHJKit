//
//  NSObject+ZHJKit.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZHJKit)

// Replace unicode character with UTF-8 string
+ (NSString *)stringByReplaceUnicode:(NSString *)string;

@end
