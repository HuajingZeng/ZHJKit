//
//  ZHJGestureUnlockView.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJGestureUnlockView.h"
#import "UIView+ZHJKit.h"

@interface ZHJGestureUnlockView ()
@property (nonatomic, strong) NSMutableArray *selectedButtons;
@property (nonatomic, assign) CGPoint currentPoint;
@end


@implementation ZHJGestureUnlockView

- (instancetype)initWithFrame:(CGRect)frame buttonSize:(CGFloat)buttonSize space:(CGFloat)space image:(UIImage *)image selectedImage:(UIImage *)selectedImage lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor {
    if (self = [super initWithFrame:frame]) {
        _buttonSize = buttonSize;
        _space = space;
        _image = image;
        _selectedImage = selectedImage;
        _lineWidth = lineWidth;
        _lineColor = lineColor;
        [self setupButtons];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero buttonSize:0 space:10 image:nil selectedImage:nil lineWidth:2 lineColor:[UIColor whiteColor]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame buttonSize:0 space:10 image:nil selectedImage:nil lineWidth:2 lineColor:[UIColor whiteColor]];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _buttonSize = [aDecoder decodeFloatForKey:@"_buttonSize"];
        _space = [aDecoder decodeFloatForKey:@"_space"];
        _image = [aDecoder decodeObjectForKey:@"_image"];
        _selectedImage = [aDecoder decodeObjectForKey:@"_selectedImage"];
        _lineWidth = [aDecoder decodeFloatForKey:@"_lineWidth"];
        _lineColor = [aDecoder decodeObjectForKey:@"_lineColor"];
        [self setupButtons];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeFloat:_buttonSize forKey:@"_buttonSize"];
    [aCoder encodeFloat:_space forKey:@"_space"];
    [aCoder encodeObject:_image forKey:@"_image"];
    [aCoder encodeObject:_selectedImage forKey:@"_selectedImage"];
    [aCoder encodeFloat:_lineWidth forKey:@"_lineWidth"];
    [aCoder encodeObject:_lineColor forKey:@"_lineColor"];
}

- (NSMutableArray *)selectedButtons {
    if (!_selectedButtons) {
        _selectedButtons = [[NSMutableArray alloc] init];
    }
    return _selectedButtons;
}

- (void)setupButtons {
    self.backgroundColor = [UIColor clearColor];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:_image forState:UIControlStateNormal];
        [btn setImage:_selectedImage forState:UIControlStateSelected];
        btn.tag = i+1;
        [self addSubview:btn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat left = (self.width - _buttonSize*3 - _space*2)/2;
    CGFloat right = (self.height - _buttonSize*3 - _space*2)/2;
    for (int row=0; row<3; row++) {
        for (int col=0; col<3; col++) {
            CGFloat x = left + (_buttonSize+_space)*col;
            CGFloat y = right + (_buttonSize+_space)*row;
            
            UIButton *btn = self.subviews[row*3+col];
            btn.frame = CGRectMake(x, y, _buttonSize, _buttonSize);
        }
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.selectedButtons.count == 0) return;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSUInteger count = self.selectedButtons.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.selectedButtons[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else {
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:_currentPoint ];
    
    [_lineColor set];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = _lineWidth;
    [path stroke];
}

#pragma mark - Action
- (void)pan:(UIPanGestureRecognizer *)pan {
    _currentPoint = [pan locationInView:self];
    
    [self setNeedsDisplay];
    
    for (UIButton *button in self.subviews) {
        if (CGRectContainsPoint(button.frame, _currentPoint) && button.selected == NO) {
            button.selected = YES;
            [self.selectedButtons addObject:button];
        }
    }
    
    [self layoutIfNeeded];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        NSMutableString *gesturePassword = @"".mutableCopy;
        for (UIButton *button in self.selectedButtons) {
            [gesturePassword appendFormat:@"%01ld", (long)button.tag];
            button.selected = NO;
        }
        [self.selectedButtons removeAllObjects];
        
        NSLog(@"%@", gesturePassword);
        
        if ([self.delegate respondsToSelector:@selector(gestureFinished:)]) {
            [self.delegate gestureFinished:gesturePassword];
        }
        
    }
}

@end
