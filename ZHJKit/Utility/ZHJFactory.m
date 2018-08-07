//
//  ZHJFactory.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJFactory.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ZHJFactory

#pragma mark - Foundation
//nonce
+ (NSString *)nonce {
    return [NSString stringWithFormat:@"%u",arc4random()];
}

//timestamp
+ (NSString *)timestamp {
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

//SHA1
+ (NSString *)sha1:(NSString *)input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

//UIView
+ (UIView *)viewFrame:(CGRect)frame bgColor:(UIColor *)bgColor {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = bgColor;
    return view;
}

//UILabel
+ (UILabel *)labelFrame:(CGRect)frame text:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    return label;
}

//UIImageView
+ (UIImageView *)imageViewFrame:(CGRect)frame image:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return imageView;
}

//UIButton
+ (UIButton *)buttonFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor image:(UIImage *)image bgColor:(UIColor *)bgColor {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setBackgroundColor:bgColor];
    return button;
}

//UITextField
+ (UITextField *)textFieldFrame:(CGRect)frame placeholder:(NSString *)placeholder fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor phColor:(UIColor *)phColor{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.textColor = textColor;
    [textField setValue:phColor forKeyPath:@"_placeholderLabel.textColor"];
    return textField;
}

//UITextView
+ (UITextView *)textViewFrame:(CGRect)frame fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.font = [UIFont systemFontOfSize:fontSize];
    textView.textColor = textColor;
    return textView;
}

@end
