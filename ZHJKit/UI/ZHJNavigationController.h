//
//  ZHJNavigationController.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+ZHJKit.h"

@interface ZHJNavigationController : UINavigationController

@property (nonatomic, strong) UIImageView *navigationBarBackgroundView;
@property (nonatomic, strong) UIColor *navigationBarBottomLineColor;

@end
