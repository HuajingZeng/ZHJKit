//
//  UINavigationController+ZHJKit.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "UINavigationController+ZHJKit.h"

@implementation UINavigationController (ZHJKit)

- (void)removeViewControllerAtIndex:(NSInteger)index {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.viewControllers];
    [viewControllers removeObjectAtIndex:index];
    self.viewControllers = viewControllers;
}

@end
