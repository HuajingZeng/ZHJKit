//
//  UIImage+ZHJKit.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZHJKit)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)fixOrientation;
- (UIImage *)scaleToFillSize:(CGSize)size;//完全拉伸
- (UIImage *)scaleAspectFitSize:(CGSize)size;//长边匹配，短边不足部分为空
- (UIImage *)scaleAspectFillSize:(CGSize)size;//短边匹配，长边超出部分被裁剪

@end
