//
//  UIView+ZHJKit.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "UIView+ZHJKit.h"

@implementation UIView (ZHJKit)

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y+self.frame.size.height;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x+self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)shake:(HJViewShakeDirection)dicrection times:(NSInteger)times duration:(NSTimeInterval)duration offset:(CGFloat)offset completion:(void (^)(void))completion {
    [UIView animateWithDuration:duration animations:^{
        switch (dicrection) {
            case HJViewShakeDirectionHorizontal:
            {
                [self.layer setAffineTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, offset, 0)];
                break;
            }
                
            case HJViewShakeDirectionVertical:
            {
                [self.layer setAffineTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, offset)];
                break;
            }
                
            default: break;
        }
    } completion:^(BOOL finished) {
        if (times == 0) {
            [UIView animateWithDuration:duration animations:^{
                [self.layer setAffineTransform:CGAffineTransformIdentity];
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        } else {
            [self shake:dicrection times:times-1 duration:duration offset:(-1*offset) completion:completion];
        }
    }];
}

@end
