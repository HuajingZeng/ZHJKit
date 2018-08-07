//
//  ZHJAlertView.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/7/4.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHJAlertView : UIView
@property (nonatomic, assign) CGFloat marginVertical UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat paddingTop UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat paddingVertical UI_APPEARANCE_SELECTOR;
/**
 提示图片
 */
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat imageBottom UI_APPEARANCE_SELECTOR;
/**
 提示标题
 */
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat titleBottom UI_APPEARANCE_SELECTOR;
/**
 提示内容
 */
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIFont *contentFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *contentColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat contentBottom UI_APPEARANCE_SELECTOR;
/**
 横线
 */
@property (nonatomic, strong) UIColor *lineColor UI_APPEARANCE_SELECTOR;
/**
 按钮
 */
@property (nonatomic, assign) CGFloat buttonHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *buttonFont UI_APPEARANCE_SELECTOR;
/**
 左按钮
 */
@property (nonatomic, strong) NSString *leftButtonTitle;
@property (nonatomic, strong) UIColor *leftButtonTitleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *leftButtonBackgroundColor UI_APPEARANCE_SELECTOR;
/**
 右按钮
 */
@property (nonatomic, strong) NSString *rightButtonTitle;
@property (nonatomic, strong) UIColor *rightButtonTitleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *rightButtonBackgroundColor UI_APPEARANCE_SELECTOR;
/**
 半径
 */
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;
/**
 按钮点击事件回调
 */
@property (nonatomic, copy) void (^leftButtonClickBlock)(void);
@property (nonatomic, copy) void (^rightButtonClickBlock)(void);

- (instancetype)initWithMarginVertical:(CGFloat)marginVertical
							paddingTop:(CGFloat)paddingTop
					   paddingVertical:(CGFloat)paddingVertical
								 image:(UIImage *)image
							 imageSize:(CGSize)imageSize
						   imageBottom:(CGFloat)imageBottom
								 title:(NSString *)title
							 titleFont:(UIFont *)titleFont
					   		titleColor:(UIColor *)titleColor
						   titleBottom:(CGFloat)titleBottom
							   content:(NSString *)content
						   contentFont:(UIFont *)contentFont
						  contentColor:(UIColor *)contentColor
						 contentBottom:(CGFloat)contentBottom
							 lineColor:(UIColor *)lineColor
						  buttonHeight:(CGFloat)buttonHeight
					   		buttonFont:(UIFont *)buttonFont
					   leftButtonTitle:(NSString *)leftButtonTitle
				  leftButtonTitleColor:(UIColor *)leftButtonTitleColor
			 leftButtonBackgroundColor:(UIColor *)leftButtonBackgroundColor
					  rightButtonTitle:(NSString *)rightButtonTitle
				 rightButtonTitleColor:(UIColor *)rightButtonTitleColor
	   		rightButtonBackgroundColor:(UIColor *)rightButtonBackgroundColor
						  cornerRadius:(CGFloat)cornerRadius NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithImage:(UIImage *)image
					imageSize:(CGSize)imageSize
						title:(NSString *)title
					  content:(NSString *)content
			  leftButtonTitle:(NSString *)leftButtonTitle
			 rightButtonTitle:(NSString *)rightButtonTitle;

- (instancetype)initWithTitle:(NSString *)title
					  content:(NSString *)content
			  leftButtonTitle:(NSString *)leftButtonTitle
			 rightButtonTitle:(NSString *)rightButtonTitle;

- (instancetype)initWithImage:(UIImage *)image
					imageSize:(CGSize)imageSize
					  content:(NSString *)content
			  leftButtonTitle:(NSString *)leftButtonTitle
			 rightButtonTitle:(NSString *)rightButtonTitle;

- (instancetype)init NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:imageDirection:space:");
- (instancetype)initWithFrame:(CGRect)frame NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:imageDirection:space:");

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (void)encodeWithCoder:(NSCoder *)aCoder;

- (void)showInViewController:(UIViewController *)viewController;
- (void)dismiss;

@end
