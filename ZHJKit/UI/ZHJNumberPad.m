//
//  ZHJNumberPad.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJNumberPad.h"
#import "UIButton+ZHJKit.h"
#import "UIView+ZHJKit.h"
#import "ZHJMarco.h"

@interface ZHJNumberPad()
@property (nonatomic, strong) NSMutableArray<UIButton *> *numBtns;
@property (nonatomic, strong) UIButton *delBtn;
@end

@implementation ZHJNumberPad

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnWidth = (self.bounds.size.width-1.0)/3.0;
    CGFloat btnHeight = (self.height-(ZHJ_TABBAR_HEIGHT-49)-2.0)/4.0;
    
    for (int i=0; i<self.numBtns.count; i++) {
        UIButton *btn = self.numBtns[i];
        if (i==0) {
            btn.frame = CGRectMake(btnWidth+0.5, (btnHeight+0.5)*3+0.5, btnWidth, btnHeight);
        }else {
            NSInteger row = floor((i-1)/3.0);
            NSInteger column = (i-1)%3;
            btn.frame = CGRectMake((btnWidth+0.5)*column, (btnHeight+0.5)*row+0.5, btnWidth, btnHeight);
        }
    }
    
    self.delBtn.frame = CGRectMake((btnWidth+0.5)*2, (btnHeight+0.5)*3+0.5, btnWidth, btnHeight);
}

#pragma mark - Event Response
- (void)numBtnTap:(UIButton *)btn {
    if (self.numBtnTapBlock) {
        self.numBtnTapBlock(btn.tag-1);
    }
}

- (void)delBtnTap {
    if (self.delBtnTapBlock) {
        self.delBtnTapBlock();
    }
}

#pragma mark - Getter
- (NSMutableArray<UIButton *> *)numBtns {
    if (!_numBtns) {
        _numBtns = [NSMutableArray array];
        for (int i=0; i<10; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.eventTimeInterval = CGFLOAT_MIN;
            btn.tag = i+1;
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:22]];
            [btn addTarget:self action:@selector(numBtnTap:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [_numBtns addObject:btn];
        }
    }
    return _numBtns;
}

- (UIButton *)delBtn {
    if (!_delBtn) {
        _delBtn = [[UIButton alloc] init];
        _delBtn.backgroundColor = [UIColor clearColor];
        _delBtn.eventTimeInterval = CGFLOAT_MIN;
        [_delBtn setImage:ZHJ_IMAGE(@"HJNumberPadDelete") forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delBtnTap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_delBtn];
    }
    return _delBtn;
}

@end
