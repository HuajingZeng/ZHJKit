//
//  ZHJBadgeButton.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJBadgeButton.h"
#import "NSString+ZHJKit.h"
#import "ZHJMarco.h"

@interface ZHJBadgeButton ()
@property (nonatomic, strong) UILabel *badgeLabel;
@end

@implementation ZHJBadgeButton

- (instancetype)initWithFrame:(CGRect)frame badgeFontSize:(CGFloat)badgeFontSize badgePadding:(CGFloat)badgePadding badgeBorderWidth:(CGFloat)badgeBorderWidth badgeTextColor:(UIColor *)badgeTextColor badgeBackgroundColor:(UIColor *)badgeBackgroundColor imageDirection:(ZHJButtonImageDirection)direction space:(CGFloat)space titleSize:(CGSize)titleSize iamgeSize:(CGSize)iamgeSize {
    if (self = [super initWithFrame:frame imageDirection:direction space:space titleSize:titleSize iamgeSize:iamgeSize]) {
        _badgeFontSize = badgeFontSize;
        _badgePadding = badgePadding;
        _badgeBorderWidth = badgeBorderWidth;
        _badgeTextColor = badgeTextColor;
        _badgeBackgroundColor = badgeBackgroundColor;
        [self setBadgeString:@"0"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame badgeFontSize:(CGFloat)badgeFontSize badgePadding:(CGFloat)badgePadding badgeBorderWidth:(CGFloat)badgeBorderWidth badgeTextColor:(UIColor *)badgeTextColor badgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    return [self initWithFrame:frame badgeFontSize:badgeFontSize badgePadding:badgePadding badgeBorderWidth:badgeBorderWidth badgeTextColor:badgeTextColor badgeBackgroundColor:badgeBackgroundColor imageDirection:ZHJButtonImageDirectionLeft space:0 titleSize:CGSizeZero iamgeSize:CGSizeZero];
}

- (instancetype)initWithFrame:(CGRect)frame imageDirection:(ZHJButtonImageDirection)direction space:(CGFloat)space titleSize:(CGSize)titleSize iamgeSize:(CGSize)imageSize {
    return [self initWithFrame:frame badgeFontSize:10 badgePadding:3 badgeBorderWidth:0 badgeTextColor:[UIColor whiteColor] badgeBackgroundColor:[UIColor redColor] imageDirection:direction space:space titleSize:titleSize iamgeSize:imageSize];
}

#pragma mark - <NSCoding>
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _badgeString = [aDecoder decodeObjectForKey:@"_badgeString"];
        _badgeFontSize = [aDecoder decodeFloatForKey:@"_badgeFontSize"];
        _badgeTextColor = [aDecoder decodeObjectForKey:@"_badgeTextColor"];
        _badgeBackgroundColor = [aDecoder decodeObjectForKey:@"_badgeBackgroundColor"];
        [self setBadgeString:_badgeString];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_badgeString forKey:@"_badgeString"];
    [aCoder encodeFloat:_badgeFontSize forKey:@"_badgeFontSize"];
    [aCoder encodeObject:_badgeTextColor forKey:@"_badgeTextColor"];
    [aCoder encodeObject:_badgeBackgroundColor forKey:@"_badgeBackgroundColor"];
}

- (void)setBadgeString:(NSString *)badgeString {
    [_badgeLabel removeFromSuperview];
    if (badgeString.length > 0) {
        CGFloat badgeWidth = [badgeString widthWithFontSize:_badgeFontSize];
        badgeWidth = badgeWidth<_badgeFontSize ? _badgeFontSize : badgeWidth;
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageSize.width-badgeWidth/2-_badgePadding, -_badgeFontSize/2-_badgePadding, badgeWidth+_badgePadding*2, _badgeFontSize+_badgePadding*2)];
        _badgeLabel.text = badgeString;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = [UIFont systemFontOfSize:_badgeFontSize];
        _badgeLabel.textColor = _badgeTextColor;
        _badgeLabel.backgroundColor = _badgeBackgroundColor;
        ZHJ_VIEW_RADIUS_BORDER(_badgeLabel, _badgeFontSize/2+_badgePadding, _badgeBorderWidth, _badgeTextColor);
        self.imageView.clipsToBounds = NO;
        [self.imageView addSubview:_badgeLabel];
        [self.imageView bringSubviewToFront:_badgeLabel];
    }
}

@end
