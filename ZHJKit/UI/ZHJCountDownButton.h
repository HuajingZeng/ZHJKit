//
//  ZHJCountDownButton.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJButton.h"

typedef void(^ButtonClickedBlock)(void);
typedef void(^CountDownStartBlock)(void);
typedef void(^CountDownUnderwayBlock)(NSInteger restCountDownNum);
typedef void(^CountDownEndBlock)(void);

@interface ZHJCountDownButton : ZHJButton

@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign, readonly) NSInteger restCountDownNum;
@property (nonatomic, copy) ButtonClickedBlock buttonClickedBlock;
@property (nonatomic, copy) CountDownStartBlock countDownStartBlock;
@property (nonatomic, copy) CountDownUnderwayBlock countDownUnderwayBlock; // Every second
@property (nonatomic, copy) CountDownEndBlock countDownEndBlock;

- (instancetype)initWithFrame:(CGRect)frame
                     duration:(NSInteger)duration
                 clickedBlock:(ButtonClickedBlock)clickedBlock
                   startBlock:(CountDownStartBlock)startBlock
                underwayBlock:(CountDownUnderwayBlock)underwayBlock
                     endBlock:(CountDownEndBlock)endBlock
               imageDirection:(ZHJButtonImageDirection)imageDirection
                        space:(CGFloat)space
                    titleSize:(CGSize)titleSize
                    iamgeSize:(CGSize)imageSize NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame
                     duration:(NSInteger)duration
                 clickedBlock:(ButtonClickedBlock)clickedBlock
                   startBlock:(CountDownStartBlock)startBlock
                underwayBlock:(CountDownUnderwayBlock)underwayBlock
                     endBlock:(CountDownEndBlock)endBlock;

- (instancetype)initWithFrame:(CGRect)frame imageDirection:(ZHJButtonImageDirection)direction space:(CGFloat)space titleSize:(CGSize)titleSize iamgeSize:(CGSize)imageSize NS_EXTENSION_UNAVAILABLE ("Use -initWithFrame:duration:clickedBlock:startBlock:underwayBlock:endBlock:");

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (void)encodeWithCoder:(NSCoder *)aCoder;

- (void)startCountDown;

@end
