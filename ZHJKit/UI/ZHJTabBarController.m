//
//  ZHJTabBarController.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJTabBarController.h"
#import "ZHJMarco.h"
#import "ZHJFactory.h"

@interface ZHJTabBarController ()
@property (nonatomic, strong) UIView *tabBarTopLineView;
@end

@implementation ZHJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar addSubview:self.tabBarTopLineView];
}

#pragma mark - Getter
- (UIView *)tabBarTopLineView {
    if (_tabBarTopLineView) {
        _tabBarTopLineView = [ZHJFactory viewFrame:CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, 0.5) bgColor:self.tabBarTopLineColor];
    }
    return _tabBarTopLineView;
}

@end
