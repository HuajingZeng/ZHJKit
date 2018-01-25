//
//  ZHJViewController.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ZHJKit.h"

@interface ZHJViewController : UIViewController

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, copy) void (^returnBlock)(NSDictionary *dic);

@end
