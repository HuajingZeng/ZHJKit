//
//  UIViewController+ZHJKit.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "UIViewController+ZHJKit.h"

@implementation UIViewController (ZHJKit)

- (void)dismissAnimated:(BOOL)animated completion:(void(^)(void))completion {
    UIViewController *rootVC = self.presentingViewController;
    while (rootVC.presentingViewController) {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:animated completion:completion];
}

@end
