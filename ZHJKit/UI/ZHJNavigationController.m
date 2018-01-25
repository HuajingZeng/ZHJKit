//
//  ZHJNavigationController.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJNavigationController.h"
#import "ZHJMarco.h"
#import "ZHJFactory.h"

@interface ZHJNavigationController ()
@property (nonatomic, strong) UIView *navigationBarBottomLineView;
@end

@implementation ZHJNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar addSubview:self.navigationBarBackgroundView];
    
    [self.navigationBar addSubview:_navigationBarBottomLineView];
    [self.navigationBar bringSubviewToFront:_navigationBarBottomLineView];
}

#pragma mark - Getter
- (UIImageView *)navigationBarBackgroundView {
    if (!_navigationBarBackgroundView) {
        _navigationBarBackgroundView = ZHJ_IMAGEVIEW(CGRectMake(0, -ZHJ_STATUSBAR_HEIGHT, ZHJ_SCREEN_WIDTH, ZHJ_NAVBAR_HEIGHT));
    }
    return _navigationBarBackgroundView;
}

- (UIView *)navigationBarBottomLineView {
    if (!_navigationBarBottomLineView) {
        _navigationBarBottomLineView = [HJFactory viewFrame:CGRectMake(0, 43, ZHJ_SCREEN_WIDTH, 1) bgColor:self.navigationBarBottomLineColor];
    }
    return _navigationBarBottomLineView;
}

@end
