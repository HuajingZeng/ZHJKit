//
//  ZHJViewController.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJViewController.h"

@interface ZHJViewController ()

@end

@implementation ZHJViewController

#pragma mark - Initialization
- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.bgView];
}

#pragma mark - Getter
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
        _bgView.image = nil;
    }
    return _bgView;
}

@end
