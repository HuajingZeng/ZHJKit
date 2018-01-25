//
//  UIView+ZHJKit.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HJViewShakeDirection) {
    HJViewShakeDirectionHorizontal = 0,
    HJViewShakeDirectionVertical = 1,
};

@interface UIView (ZHJKit)

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

- (void)shake:(HJViewShakeDirection)dicrection times:(NSInteger)times duration:(NSTimeInterval)duration offset:(CGFloat)offset completion:(void(^)(void))completion;

@end
