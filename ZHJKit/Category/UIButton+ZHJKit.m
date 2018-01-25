//
//  UIButton+ZHJKit.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <objc/runtime.h>
#import "UIButton+ZHJKit.h"

static const NSTimeInterval _defaultInterval = 1;// Default is 1 second
static const char *_eventTimeInterval = "_eventTimeInterval";
static char _topKey;
static char _leftKey;
static char _bottomKey;
static char _rightKey;

@implementation UIButton (ZHJKit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectorA = @selector(sendAction:to:forEvent:);
        SEL selectorB = @selector(__sendAction:to:forEvent:);
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

- (void)__sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    self.eventTimeInterval = self.eventTimeInterval == 0 ? _defaultInterval : self.eventTimeInterval;
    self.userInteractionEnabled = NO;
    NSLog(@"User interaction disabled");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.eventTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        NSLog(@"User interaction enabled");
    });
    [self __sendAction:action to:target forEvent:event];
}

- (void)setEventTimeInterval:(NSTimeInterval)eventTimeInterval {
    objc_setAssociatedObject(self, _eventTimeInterval, @(eventTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)eventTimeInterval {
    return [objc_getAssociatedObject(self, _eventTimeInterval) doubleValue];
}

- (void)enlargeTouchAreaWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    objc_setAssociatedObject(self, &_topKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &_leftKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &_bottomKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &_rightKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)enlargeTouchArea:(CGFloat)size {
    objc_setAssociatedObject(self, &_topKey, [NSNumber numberWithFloat:size],OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &_leftKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &_bottomKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &_rightKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)_enlargedRect {
    NSNumber *topEdge = objc_getAssociatedObject(self, &_topKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &_leftKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &_bottomKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &_rightKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }else {
        return self.bounds;
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect rect = [self _enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
