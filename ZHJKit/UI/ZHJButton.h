//
//  ZHJButton.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

// Button image orientation
typedef NS_ENUM(NSInteger, ZHJButtonImageDirection)
{
    ZHJButtonImageDirectionLeft,// Default
    ZHJButtonImageDirectionRight,
    ZHJButtonImageDirectionTop,
    ZHJButtonImageDirectionBottom,
};

@interface ZHJButton : UIButton

@property (nonatomic, assign) ZHJButtonImageDirection imageDirection;
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, assign) CGSize titleSize;
@property (nonatomic, assign) CGSize imageSize;

- (instancetype)initWithFrame:(CGRect)frame
               imageDirection:(ZHJButtonImageDirection)direction
                        space:(CGFloat)space
                    titleSize:(CGSize)titleSize
                    iamgeSize:(CGSize)imageSize NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame imageDirection:(ZHJButtonImageDirection)direction space:(CGFloat)space;
- (instancetype)initWithFrame:(CGRect)frame imageDirection:(ZHJButtonImageDirection)direction;
- (instancetype)initWithFrame:(CGRect)frame space:(CGFloat)space;

- (instancetype)init NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:imageDirection:space:");
- (instancetype)initWithFrame:(CGRect)frame NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:imageDirection:space:");

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
