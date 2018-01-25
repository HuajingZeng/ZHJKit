//
//  NSSet+ZHJKit.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <objc/runtime.h>
#import "NSSet+ZHJKit.h"
#import "NSObject+ZHJKit.h"

@implementation NSSet (ZHJKit)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(description)), class_getInstanceMethod([self class], @selector(__description)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:)), class_getInstanceMethod([self class], @selector(__descriptionWithLocale:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:indent:)), class_getInstanceMethod([self class], @selector(__descriptionWithLocale:indent:)));
}

- (NSString *)__description {
    return [NSObject stringByReplaceUnicode:[self __description]];
}

- (NSString *)__descriptionWithLocale:(nullable id)locale {
    return [NSObject stringByReplaceUnicode:[self __descriptionWithLocale:locale]];
}

- (NSString *)__descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [NSObject stringByReplaceUnicode:[self __descriptionWithLocale:locale indent:level]];
}

@end
