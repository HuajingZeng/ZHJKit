//
//  ZHJVerticalLabel.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Text writing direction
 */
typedef NS_ENUM(NSInteger, ZHJVerticalLabelWritingDirection)
{
    ZHJVerticalLabelWritingDirectionLeftToRight,// Default
    ZHJVerticalLabelWritingDirectionRightToLeft,
};

@interface ZHJVerticalLabel : UILabel

@property (nonatomic, assign) ZHJVerticalLabelWritingDirection writingDirection;
@property (nonatomic, assign) CGFloat space;

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text direction:(ZHJVerticalLabelWritingDirection)direction space:(CGFloat)space font:(UIFont *)font textColor:(UIColor *)textColor NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:withText:withTextDirection: withSpace:withFont:withTextColor:");
- (instancetype)initWithFrame:(CGRect)frame NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:withText:withTextDirection: withSpace:withFont:withTextColor:");

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end

/**
 Calculate the size required for VerticalLabel‘s text to display
 */
@interface NSString (ZHJVerticalLabel)

- (CGSize)verticalLabelWithinSize:(CGSize)size font:(UIFont *)font space:(CGFloat)space;

@end
