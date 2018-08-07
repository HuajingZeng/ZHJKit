//
//  UITextView+ZHJKit.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (ZHJKit)

@property (nonatomic, strong, readonly) NSArray<NSString *> *illegalStrings;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, strong) NSString *regularExpression;
@property (nonatomic, copy) void (^valueChangeBlock)(UITextView *textView);

- (void)addIllegalString:(NSString *)string;
- (void)removeIllegalString:(NSString *)string;
- (void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor;

@end
