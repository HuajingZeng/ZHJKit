//
//  UIViewController+ZHJKit.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZHJKit)

- (void)dismissAllAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end
