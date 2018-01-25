//
//  UITextField+ZHJKit.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <objc/runtime.h>
#import "UITextField+ZHJKit.h"

static const char *_illegalStrings = "_illegalStrings";
static const char *_maxLength = "_maxLength";
static const char *_regularExpression = "_regularExpression";
static const char *_valueChangeBlock = "_valueChangeBlock";

@interface UITextField ()
@property (nonatomic, strong, readwrite) NSArray<NSString *> *illegalStrings;
@end

@implementation UITextField (ZHJKit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectorA = @selector(initWithFrame:);
        SEL selectorB = @selector(__initWithFrame:);
        Method methodA = class_getInstanceMethod(self, selectorA);
        Method methodB = class_getInstanceMethod(self, selectorB);
        
        BOOL isAdd = class_addMethod(self, selectorA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        
        if (isAdd) {
            class_replaceMethod(self, selectorB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            method_exchangeImplementations(methodA, methodB);
        }
    });
    
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        SEL selectorA = @selector(initWithCoder:);
        SEL selectorB = @selector(__initWithCoder:);
        Method methodA = class_getInstanceMethod(self, selectorA);
        Method methodB = class_getInstanceMethod(self, selectorB);
        
        BOOL isAdd = class_addMethod(self, selectorA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        
        if (isAdd) {
            class_replaceMethod(self, selectorB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            method_exchangeImplementations(methodA, methodB);
        }
    });
}

- (void)dealloc {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)__initWithFrame:(CGRect)frame {
    [self config];
    return [self __initWithFrame:frame];
}

- (instancetype)__initWithCoder:(NSCoder *)aDecoder {
    [self config];
    return [self __initWithCoder:aDecoder];
}

- (void)config {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChanged) name:UITextFieldTextDidChangeNotification object:nil];
    NSArray *illegalStrings = @[@"\"", @"\'"];
    [self setIllegalStrings:illegalStrings];
}

- (void)setIllegalStrings:(NSArray<NSString *> *)illegalStrings {
    objc_setAssociatedObject(self, _illegalStrings, illegalStrings, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray<NSString *> *)illegalStrings {
    return objc_getAssociatedObject(self, _illegalStrings);
}

- (void)setMaxLength:(NSInteger)maxLength {
    NSNumber *maxLengthNum = [NSNumber numberWithInteger:maxLength];
    objc_setAssociatedObject(self, _maxLength, maxLengthNum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, _maxLength) integerValue];
}

- (void)setRegularExpression:(NSString *)regularExpression {
    objc_setAssociatedObject(self, _regularExpression, regularExpression, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)regularExpression {
    return objc_getAssociatedObject(self, _regularExpression);
}

- (void)setValueChangeBlock:(void (^)(UITextField *))valueChangeBlock {
    objc_setAssociatedObject(self, _valueChangeBlock, valueChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITextField *))valueChangeBlock {
    return objc_getAssociatedObject(self, _valueChangeBlock);
}

- (void)addIllegalString:(NSString *)string {
    NSMutableArray *illegalStrings = [self.illegalStrings mutableCopy];
    if (![illegalStrings containsObject:string]) {
        [illegalStrings addObject:string];
        [self setIllegalStrings:illegalStrings];
    }
}

- (void)removeIllegalString:(NSString *)string {
    NSMutableArray *illegalStrings = [self.illegalStrings mutableCopy];
    if ([illegalStrings containsObject:string]) {
        [illegalStrings removeObject:string];
        [self setIllegalStrings:illegalStrings];
    }
}

#pragma mark - Action
- (void)valueChanged {
    NSString *lang =  [self.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        //中文输入法
        
        //获取高亮选择部分
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            // 没有高亮选择的字，表明输入结束
            [self validate];
        } else {
            //有高亮选择的字符串，则暂不对文字进行处理
            NSLog(@"%@",position);
        }
    } else {
        // 非中文输入法
        [self validate];
    }
}

- (void)validate {
    NSLog(@"%@", self.text);
    NSArray *illegalStrings = self.illegalStrings;
    UIKeyboardType keyboardType = self.keyboardType;
    NSString *regularExpression = self.regularExpression;
    NSInteger maxLength = self.maxLength;
    
    //验证非法字符
    if (illegalStrings.count>0) {
        for (NSString *illegalString in illegalStrings) {
            if ([self.text containsString:illegalString]) {
                NSLog(@"非法字符：%@", illegalString);
                self.text = [self.text stringByReplacingOccurrencesOfString:illegalString withString:@""];
            }
        }
    }
    
    //验证键盘类型
    switch (keyboardType) {
        case UIKeyboardTypeNumberPad:
        {
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:nil];
            NSMutableString *copyText = [self.text mutableCopy];
            [reg replaceMatchesInString:copyText options:0 range:NSMakeRange(0, copyText.length) withTemplate:@""];
            self.text = copyText;
            break;
        }
            
        case UIKeyboardTypePhonePad:
        {
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"[^0-9+*#]" options:0 error:nil];
            NSMutableString *copyText = [self.text mutableCopy];
            [reg replaceMatchesInString:copyText options:0 range:NSMakeRange(0, copyText.length) withTemplate:@""];
            self.text = copyText;
            break;
        }
            
        case UIKeyboardTypeDecimalPad:
        {
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"[^0-9.]" options:0 error:nil];
            NSMutableString *copyText = [self.text mutableCopy];
            [reg replaceMatchesInString:copyText options:0 range:NSMakeRange(0, copyText.length) withTemplate:@""];
            self.text = copyText;
            break;
        }
            
        default:
            break;
    }
    
    //验证正则表达式
    if (regularExpression.length>0) {
        NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regularExpression options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSArray *matches = [regEx matchesInString:self.text options:NSMatchingReportProgress range:NSMakeRange(0, self.text.length)];
        if (matches.count>0) {
            NSTextCheckingResult *result = matches[0];
            NSRange range = result.range;
            self.text = [self.text substringWithRange:range];
        }else {
            self.text = @"";
        }
    }
    
    //验证字符数
    if (maxLength>0 && self.text.length > maxLength) {
        NSLog(@"最大长度：%ld", (long)maxLength);
        self.text = [self.text substringToIndex:maxLength];
    }
    
    //调用block
    if (self.valueChangeBlock) {
        self.valueChangeBlock(self);
    }
}

@end
