//
//  NSString+ZHJKit.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "NSString+ZHJKit.h"

@implementation NSString (ZHJKit)

#pragma mark - Regular Expression
- (NSArray<NSTextCheckingResult *> *)searchByRegEx:(NSString *)regex {
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matches = [regularExpression matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    return matches;
}

- (BOOL)matchRegEx:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isTelephone {
    NSString *MP = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";// Mobile Phone
    NSString *CMCC = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";// China Mobile Communications Corporation
    NSString *CUCC = @"^1(3[0-2]|5[256]|8[56]\\d|709)\\d{7}$";// China Unicom Communications Corporation
    NSString *CTC = @"^1((33|53|8[09])[0-9]\\d|349|700)\\d{7}$";// China Telecommunications Corporation
    NSString *PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";// Personal Handphone System
    
    return ([self matchRegEx:MP] || [self matchRegEx:CMCC] || [self matchRegEx:CUCC] || [self matchRegEx:CTC] || [self matchRegEx:PHS]);
}

- (BOOL)isPassword {
    NSString *regex = @"(^[A-Za-z0-9]{6,20}$)";
    return [self matchRegEx:regex];
}

- (BOOL)isNumber {
    NSString *regex = @"^-?\\d+.?\\d?";
    return [self matchRegEx:regex];
}

- (BOOL)isEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self matchRegEx:regex];
}

- (BOOL)isUrl {
    NSString *regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    return [self matchRegEx:regex];
}

#pragma mark - URL
- (NSDictionary *)getURLParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([self containsString:@"&"]) {
        NSArray *urlComponents = [self componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                } else {
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                [params setValue:value forKey:key];
            }
        }
    } else {
        NSArray *pairComponents = [self componentsSeparatedByString:@"="];

        if (pairComponents.count == 1) {
            return nil;
        }

        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];

        if (key == nil || value == nil) {
            return nil;
        }
        [params setValue:value forKey:key];
    }
    return [params copy];
}

#pragma mark - Text Size
- (CGFloat)heightWithFont:(UIFont *)font withParagraphStyle:(NSParagraphStyle *)paragraphStyle withinSize:(CGSize)size {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    
    if (paragraphStyle) {
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    
    CGSize textSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return textSize.height;
}

- (CGFloat)heightWithFontSize:(CGFloat)fontSize withinSize:(CGSize)size {
    return [self heightWithFont:[UIFont systemFontOfSize:fontSize] withParagraphStyle:nil withinSize:size];
}

- (CGFloat)heightWithBoldFontSize:(CGFloat)fontSize withinSize:(CGSize)size {
    return [self heightWithFont:[UIFont boldSystemFontOfSize:fontSize] withParagraphStyle:nil withinSize:size];
}

- (CGFloat)widthWithFont:(UIFont *)font withParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    if (paragraphStyle) {
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, font.pointSize) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return textSize.width;
}

- (CGFloat)widthWithFontSize:(CGFloat)fontSize {
    return [self widthWithFont:[UIFont systemFontOfSize:fontSize] withParagraphStyle:nil];
}

- (CGFloat)widthWithBoldFontSize:(CGFloat)fontSize {
    return [self widthWithFont:[UIFont boldSystemFontOfSize:fontSize] withParagraphStyle:nil];
}

@end
