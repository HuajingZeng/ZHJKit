//
//  ZHJNumberPad.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHJNumberPad : UIView

@property (nonatomic, copy) void (^numBtnTapBlock)(NSInteger num);
@property (nonatomic, copy) void (^delBtnTapBlock)(void);

@end
