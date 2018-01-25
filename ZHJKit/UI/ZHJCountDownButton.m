//
//  ZHJCountDownButton.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJCountDownButton.h"

@interface ZHJCountDownButton ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign, readwrite) NSInteger restCountDownNum;

@end

@implementation ZHJCountDownButton


- (instancetype)initWithFrame:(CGRect)frame duration:(NSInteger)duration clickedBlock:(ButtonClickedBlock)clickedBlock startBlock:(CountDownStartBlock)startBlock underwayBlock:(CountDownUnderwayBlock)underwayBlock endBlock:(CountDownEndBlock)endBlock imageDirection:(ZHJButtonImageDirection)imageDirection space:(CGFloat)space titleSize:(CGSize)titleSize iamgeSize:(CGSize)imageSize {
    if (self = [super initWithFrame:frame imageDirection:imageDirection space:space titleSize:titleSize iamgeSize:imageSize]) {
        _restCountDownNum = _duration = duration;
        self.buttonClickedBlock = clickedBlock;
        self.countDownStartBlock = startBlock;
        self.countDownUnderwayBlock = underwayBlock;
        self.countDownEndBlock = endBlock;
        [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame duration:(NSInteger)duration clickedBlock:(ButtonClickedBlock)clickedBlock startBlock:(CountDownStartBlock)startBlock underwayBlock:(CountDownUnderwayBlock)underwayBlock endBlock:(CountDownEndBlock)endBlock {
    return [self initWithFrame:frame duration:duration clickedBlock:clickedBlock startBlock:startBlock underwayBlock:underwayBlock endBlock:endBlock imageDirection:ZHJButtonImageDirectionLeft space:0 titleSize:CGSizeZero iamgeSize:CGSizeZero];
}

- (instancetype)initWithFrame:(CGRect)frame imageDirection:(ZHJButtonImageDirection)direction space:(CGFloat)space titleSize:(CGSize)titleSize iamgeSize:(CGSize)imageSize {
    return [self initWithFrame:frame duration:60 clickedBlock:nil startBlock:nil underwayBlock:nil endBlock:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _duration = [aDecoder decodeIntegerForKey:@"_duration"];
        _restCountDownNum = [aDecoder decodeIntegerForKey:@"_restCountDownNum"];
        _timer = [aDecoder decodeObjectForKey:@"_timer"];
        _buttonClickedBlock = [aDecoder decodeObjectForKey:@"_buttonClickedBlock"];
        _countDownStartBlock = [aDecoder decodeObjectForKey:@"_countDownStartBlock"];
        _countDownUnderwayBlock = [aDecoder decodeObjectForKey:@"_countDownUnderwayBlock"];
        _countDownEndBlock = [aDecoder decodeObjectForKey:@"_countDownEndBlock"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:_duration forKey:@"_duration"];
    [aCoder encodeInteger:_restCountDownNum forKey:@"_restCountDownNum"];
    [aCoder encodeObject:_timer forKey:@"_timer"];
    [aCoder encodeObject:_buttonClickedBlock forKey:@"_buttonClickedBlock"];
    [aCoder encodeObject:_countDownStartBlock forKey:@"_countDownStartBlock"];
    [aCoder encodeObject:_countDownUnderwayBlock forKey:@"_countDownUnderwayBlock"];
    [aCoder encodeObject:_countDownEndBlock forKey:@"_countDownEndBlock"];
}

#pragma mark - Initialization
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(refreshButton) userInfo:nil repeats:YES];
    }
    return _timer;
}


#pragma mark - Action
- (void)startCountDown {
    self.enabled = NO;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    _restCountDownNum = _duration;
    self.countDownStartBlock();
}

- (void)buttonClicked:(ZHJCountDownButton *)sender {
    self.buttonClickedBlock();
}

- (void)refreshButton {
    _restCountDownNum --;
    self.countDownUnderwayBlock(_restCountDownNum);
    if (_restCountDownNum == 0) {
        [self.timer invalidate];
        self.timer = nil;
        _restCountDownNum = _duration;
        self.countDownEndBlock();
        self.enabled = YES;
    }
}

- (void)dealloc {
    self.timer = nil;
}


@end
