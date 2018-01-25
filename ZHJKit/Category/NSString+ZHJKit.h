//
//  NSString+ZHJKit.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (ZHJKit)

#pragma mark - Regular Expression
// Return the array of results that match the regular expression
- (NSArray<NSTextCheckingResult *> *)searchByRegEx:(NSString *)regex;

// Verify whether matching regular expressions
- (BOOL)matchRegEx:(NSString *)regex;

// Convenient verification method
- (BOOL)isTelephone;// CMCC, CUCC, CTC, PHS, etc.
- (BOOL)isPassword;// 6-20 characters(Letters and numbers)
- (BOOL)isNumber;
- (BOOL)isEmail;
- (BOOL)isUrl;

#pragma mark - URL
// Return a dictionary from a query string
- (NSDictionary *)getURLParameters;

#pragma mark - Text Size
// Return the height required to display a string
- (CGFloat)heightWithFont:(UIFont *)font withParagraphStyle:(NSParagraphStyle *)paragraphStyle withinSize:(CGSize)size;
- (CGFloat)heightWithFontSize:(CGFloat)fontSize withinSize:(CGSize)size;
- (CGFloat)heightWithBoldFontSize:(CGFloat)fontSize withinSize:(CGSize)size;

// Return the width of a single line display string
- (CGFloat)widthWithFont:(UIFont *)font withParagraphStyle:(NSParagraphStyle *)paragraphStyle;
- (CGFloat)widthWithFontSize:(CGFloat)fontSize;
- (CGFloat)widthWithBoldFontSize:(CGFloat)fontSize;

@end
