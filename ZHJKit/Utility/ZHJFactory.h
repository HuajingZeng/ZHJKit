//
//  ZHJFactory.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DateAccuracy) {
    DateAccuracyDay = 0,
    DateAccuracyHour = 1,
    DateAccuracyMinute = 2,
    DateAccuracySecond = 3,
};

@interface HJFactory : NSObject

#pragma mark - Foundation
//nonce
+ (NSString *)nonce;

//timestamp
+ (NSString *)timestamp;

//SHA1
+ (NSString *)sha1:(NSString *)input;

//formatDate
+ (NSString *)formatDate:(NSDate *)date withString:(NSString *)string;

+ (NSString *)formatDateFrom:(NSDate *)startDate to:(NSDate *)endDate accuracy:(DateAccuracy)dateAccuracy;

+ (NSDate *)dateFormDateString:(NSString *)dateString formatString:(NSString *)formatString;

#pragma mark - UIKit
//UIView
+ (UIView *)viewFrame:(CGRect)frame bgColor:(UIColor *)bgColor;

//UILabel
+ (UILabel *)labelFrame:(CGRect)frame text:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor;

//UIImageView
+ (UIImageView *)imageViewFrame:(CGRect)frame image:(UIImage *)image;

//UIButton
+ (UIButton *)buttonFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor image:(UIImage *)image bgColor:(UIColor *)bgColor;

//UITextField
+ (UITextField *)textFieldFrame:(CGRect)frame placeholder:(NSString *)placeholder fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor phColor:(UIColor *)phColor;

//UITextView
+ (UITextView *)textViewFrame:(CGRect)frame fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor;

@end
