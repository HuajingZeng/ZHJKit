//
//  ZHJDropDownMenuBar.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJDropDownMenuBar.h"
#import "ZHJButton.h"

@interface ZHJDropDownMenuBar ()
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) ZHJButton *selectedBtn;
@end

@implementation ZHJDropDownMenuBar

- (instancetype)initWithFrame:(CGRect)frame numberOfItems:(NSInteger)number delegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger num = number>0 ? number : 1;
        CGFloat btnWidth = frame.size.width/num;
        CGFloat btnHeight = frame.size.height;
        
        _btns = [NSMutableArray array];
        for (int i=0; i<num; i++) {
            ZHJButton *btn = [[ZHJButton alloc] initWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, btnHeight) imageDirection:ZHJButtonImageDirectionRight space:5];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_btns addObject:btn];
            [self addSubview:btn];
        }
        
        _delegate = delegate;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame numberOfItems:(NSInteger)number {
    return [self initWithFrame:frame numberOfItems:number delegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate {
    return [self initWithFrame:frame numberOfItems:1 delegate:delegate];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero numberOfItems:1 delegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfItems:1 delegate:nil];
}

#pragma mark - <NSCoding>
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _btns = [aDecoder decodeObjectForKey:@"_btns"];
        _selectedBtn = [aDecoder decodeObjectForKey:@"_selectedBtn"];
        _delegate = [aDecoder decodeObjectForKey:@"_delegate"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_btns forKey:@"_btns"];
    [aCoder encodeObject:_selectedBtn forKey:@"_selectedBtn"];
    [aCoder encodeObject:_delegate forKey:@"_delegate"];
}

#pragma mark - Setter
- (void)setItemTitleFont:(UIFont *)font {
    for (ZHJButton *btn in _btns) {
        btn.titleLabel.font = font;
    }
}

- (void)setItemTitleColor:(UIColor *)color forState:(UIControlState)state {
    for (ZHJButton *btn in _btns) {
        [btn setTitleColor:color forState:state];
    }
}

- (void)setItemTitles:(NSArray<NSString *> *)titles forState:(UIControlState)state {
    if (titles.count == _btns.count) {
        for (int i=0; i<titles.count; i++) {
            ZHJButton *btn = (ZHJButton *)_btns[i];
            [btn setTitle:titles[i] forState:state];
        }
    }
}

- (void)setItemImage:(UIImage *)image forState:(UIControlState)state {
    for (ZHJButton *btn in _btns) {
        [btn setImage:image forState:state];
    }
}

- (void)setItemImages:(NSArray<UIImage *> *)images forState:(UIControlState)state {
    if (images.count == _btns.count) {
        for (int i=0; i<images.count; i++) {
            ZHJButton *btn = (ZHJButton *)_btns[i];
            [btn setImage:images[i] forState:state];
        }
    }
}

- (void)selectItemAtIndex:(NSInteger)index {
    if (index<_btns.count) {
        for (int i=0; i<_btns.count; i++) {
            BOOL match = (index==i);
            ZHJButton *btn = _btns[i];
            btn.selected = match ? !btn.selected : NO;
            _selectedBtn = match ? btn : _selectedBtn;
        }
    }
}

#pragma mark - Action
- (void)btnClick:(ZHJButton *)btn {
    if (btn != _selectedBtn) {
        _selectedBtn.selected = NO;
    }
    btn.selected = !btn.selected;
    _selectedBtn = btn;
    if (_delegate) {
        [_delegate menuBar:self didSelectItemAtIndex:btn.tag-1];
    }
}

@end
