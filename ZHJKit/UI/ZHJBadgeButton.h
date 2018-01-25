//
//  ZHJBadgeButton.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJButton.h"

@interface ZHJBadgeButton : ZHJButton

@property (nonatomic, strong) NSString *badgeString;
@property (nonatomic, assign) CGFloat badgeFontSize;
@property (nonatomic, assign) CGFloat badgePadding;
@property (nonatomic, assign) CGFloat badgeBorderWidth;
@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, strong) UIColor *badgeBackgroundColor;

- (instancetype)initWithFrame:(CGRect)frame
                badgeFontSize:(CGFloat)badgeFontSize
                 badgePadding:(CGFloat)badgePadding
             badgeBorderWidth:(CGFloat)badgeBorderWidth
                   badgeTextColor:(UIColor *)badgeTextColor
         badgeBackgroundColor:(UIColor *)badgeBackgroundColor
               imageDirection:(ZHJButtonImageDirection)direction
                        space:(CGFloat)space
                    titleSize:(CGSize)titleSize
                    iamgeSize:(CGSize)iamgeSize NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame
                badgeFontSize:(CGFloat)badgeFontSize
                 badgePadding:(CGFloat)badgePadding
             badgeBorderWidth:(CGFloat)badgeBorderWidth
                   badgeTextColor:(UIColor *)badgeTextColor
         badgeBackgroundColor:(UIColor *)badgeBackgroundColor;

-(instancetype)initWithFrame:(CGRect)frame imageDirection:(ZHJButtonImageDirection)direction space:(CGFloat)space titleSize:(CGSize)titleSize iamgeSize:(CGSize)imageSize NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:numFontSize:padding:borderWidth:imageDirection:space:titleSize:iamgeSize:");

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (void)encodeWithCoder:(NSCoder *)aCoder;


@end
