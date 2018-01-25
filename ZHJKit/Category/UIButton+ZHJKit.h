//
//  UIButton+ZHJKit.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZHJKit)

@property (nonatomic, assign) NSTimeInterval eventTimeInterval;

/**
 Increase the response area with different size
 */
- (void)enlargeTouchAreaWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

/**
 Increase the response area with the same size
 */
- (void)enlargeTouchArea:(CGFloat)size;

@end
