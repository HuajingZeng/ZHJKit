//
//  ZHJAlertView.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/7/4.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJAlertView.h"
#import "ZHJPopups.h"
#import "ZHJMarco.h"
#import "NSString+ZHJKit.h"
#import "UIView+ZHJKit.h"

@interface ZHJAlertView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation ZHJAlertView

+ (void)load {
	[[ZHJAlertView appearance] setMarginVertical:40];
	[[ZHJAlertView appearance] setPaddingTop:18];
	[[ZHJAlertView appearance] setPaddingVertical:18];
	[[ZHJAlertView appearance] setImageBottom:18];
	[[ZHJAlertView appearance] setTitleFont:[UIFont systemFontOfSize:16]];
	[[ZHJAlertView appearance] setTitleColor:[UIColor grayColor]];
	[[ZHJAlertView appearance] setTitleBottom:18];
	[[ZHJAlertView appearance] setContentFont:[UIFont systemFontOfSize:14]];
	[[ZHJAlertView appearance] setContentColor:[UIColor grayColor]];
	[[ZHJAlertView appearance] setContentBottom:22];
	[[ZHJAlertView appearance] setButtonHeight:45];
	[[ZHJAlertView appearance] setButtonFont:[UIFont systemFontOfSize:15]];
	[[ZHJAlertView appearance] setLeftButtonTitleColor:[UIColor grayColor]];
	[[ZHJAlertView appearance] setLeftButtonBackgroundColor:[UIColor whiteColor]];
	[[ZHJAlertView appearance] setRightButtonTitleColor:[UIColor whiteColor]];
	[[ZHJAlertView appearance] setRightButtonBackgroundColor:[UIColor orangeColor]];
	[[ZHJAlertView appearance] setCornerRadius:4];
}

#pragma mark - Initialization
- (instancetype)initWithMarginVertical:(CGFloat)marginVertical paddingTop:(CGFloat)paddingTop paddingVertical:(CGFloat)paddingVertical image:(UIImage *)image imageSize:(CGSize)imageSize imageBottom:(CGFloat)imageBottom title:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor titleBottom:(CGFloat)titleBottom content:(NSString *)content contentFont:(UIFont *)contentFont contentColor:(UIColor *)contentColor contentBottom:(CGFloat)contentBottom lineColor:(UIColor *)lineColor buttonHeight:(CGFloat)buttonHeight buttonFont:(UIFont *)buttonFont leftButtonTitle:(NSString *)leftButtonTitle leftButtonTitleColor:(UIColor *)leftButtonTitleColor leftButtonBackgroundColor:(UIColor *)leftButtonBackgroundColor rightButtonTitle:(NSString *)rightButtonTitle rightButtonTitleColor:(UIColor *)rightButtonTitleColor rightButtonBackgroundColor:(UIColor *)rightButtonBackgroundColor cornerRadius:(CGFloat)cornerRadius {
	if (self = [super initWithFrame:CGRectZero]) {
		self.backgroundColor = [UIColor whiteColor];
		_marginVertical = marginVertical;
		_paddingTop = paddingTop;
		_paddingVertical = paddingVertical;
		_image = image;
		_imageSize = imageSize;
		_imageBottom = imageBottom;
		_title = title;
		_titleFont = titleFont;
		_titleColor = titleColor;
		_titleBottom = titleBottom;
		_content = content;
		_contentFont = contentFont;
		_contentColor = contentColor;
		_contentBottom = contentBottom;
		_lineColor = lineColor;
		_buttonHeight = buttonHeight;
		_buttonFont = buttonFont;
		_leftButtonTitle = leftButtonTitle;
		_leftButtonTitleColor = leftButtonTitleColor;
		_leftButtonBackgroundColor = leftButtonBackgroundColor;
		_rightButtonTitle = rightButtonTitle;
		_rightButtonTitleColor = rightButtonTitleColor;
		_rightButtonBackgroundColor = rightButtonBackgroundColor;
		_cornerRadius = cornerRadius;
	}
	return self;
}

- (instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString *)title content:(NSString *)content leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle {
	return [self initWithMarginVertical:[ZHJAlertView appearance].marginVertical paddingTop:[ZHJAlertView appearance].paddingTop paddingVertical:[ZHJAlertView appearance].paddingVertical image:image imageSize:imageSize imageBottom:[ZHJAlertView appearance].imageBottom title:title titleFont:[ZHJAlertView appearance].titleFont titleColor:[ZHJAlertView appearance].titleColor titleBottom:[ZHJAlertView appearance].titleBottom content:content contentFont:[ZHJAlertView appearance].contentFont contentColor:[ZHJAlertView appearance].contentColor contentBottom:[ZHJAlertView appearance].contentBottom lineColor:[ZHJAlertView appearance].lineColor buttonHeight:[ZHJAlertView appearance].buttonHeight buttonFont:[ZHJAlertView appearance].buttonFont leftButtonTitle:leftButtonTitle leftButtonTitleColor:[ZHJAlertView appearance].leftButtonTitleColor leftButtonBackgroundColor:[ZHJAlertView appearance].leftButtonBackgroundColor rightButtonTitle:rightButtonTitle rightButtonTitleColor:[ZHJAlertView appearance].rightButtonTitleColor rightButtonBackgroundColor:[ZHJAlertView appearance].rightButtonBackgroundColor cornerRadius:[ZHJAlertView appearance].cornerRadius];
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle {
	return [self initWithMarginVertical:[ZHJAlertView appearance].marginVertical paddingTop:[ZHJAlertView appearance].paddingTop paddingVertical:[ZHJAlertView appearance].paddingVertical image:nil imageSize:CGSizeZero imageBottom:[ZHJAlertView appearance].imageBottom title:title titleFont:[ZHJAlertView appearance].titleFont titleColor:[ZHJAlertView appearance].titleColor titleBottom:[ZHJAlertView appearance].titleBottom content:content contentFont:[ZHJAlertView appearance].contentFont contentColor:[ZHJAlertView appearance].contentColor contentBottom:[ZHJAlertView appearance].contentBottom lineColor:[ZHJAlertView appearance].lineColor buttonHeight:[ZHJAlertView appearance].buttonHeight buttonFont:[ZHJAlertView appearance].buttonFont leftButtonTitle:leftButtonTitle leftButtonTitleColor:[ZHJAlertView appearance].leftButtonTitleColor leftButtonBackgroundColor:[ZHJAlertView appearance].leftButtonBackgroundColor rightButtonTitle:rightButtonTitle rightButtonTitleColor:[ZHJAlertView appearance].rightButtonTitleColor rightButtonBackgroundColor:[ZHJAlertView appearance].rightButtonBackgroundColor cornerRadius:[ZHJAlertView appearance].cornerRadius];
}

- (instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize content:(NSString *)content leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle {
	return [self initWithMarginVertical:[ZHJAlertView appearance].marginVertical paddingTop:[ZHJAlertView appearance].paddingTop paddingVertical:[ZHJAlertView appearance].paddingVertical image:image imageSize:imageSize imageBottom:[ZHJAlertView appearance].imageBottom title:nil titleFont:[ZHJAlertView appearance].titleFont titleColor:[ZHJAlertView appearance].titleColor titleBottom:[ZHJAlertView appearance].titleBottom content:content contentFont:[ZHJAlertView appearance].contentFont contentColor:[ZHJAlertView appearance].contentColor contentBottom:[ZHJAlertView appearance].contentBottom lineColor:[ZHJAlertView appearance].lineColor buttonHeight:[ZHJAlertView appearance].buttonHeight buttonFont:[ZHJAlertView appearance].buttonFont leftButtonTitle:leftButtonTitle leftButtonTitleColor:[ZHJAlertView appearance].leftButtonTitleColor leftButtonBackgroundColor:[ZHJAlertView appearance].leftButtonBackgroundColor rightButtonTitle:rightButtonTitle rightButtonTitleColor:[ZHJAlertView appearance].rightButtonTitleColor rightButtonBackgroundColor:[ZHJAlertView appearance].rightButtonBackgroundColor cornerRadius:[ZHJAlertView appearance].cornerRadius];
}

- (instancetype)init {
	return [self initWithMarginVertical:[ZHJAlertView appearance].marginVertical paddingTop:[ZHJAlertView appearance].paddingTop paddingVertical:[ZHJAlertView appearance].paddingVertical image:nil imageSize:CGSizeZero imageBottom:[ZHJAlertView appearance].imageBottom title:@"" titleFont:[ZHJAlertView appearance].titleFont titleColor:[ZHJAlertView appearance].titleColor titleBottom:[ZHJAlertView appearance].titleBottom content:@"" contentFont:[ZHJAlertView appearance].contentFont contentColor:[ZHJAlertView appearance].contentColor contentBottom:[ZHJAlertView appearance].contentBottom lineColor:[ZHJAlertView appearance].lineColor buttonHeight:[ZHJAlertView appearance].buttonHeight buttonFont:[ZHJAlertView appearance].buttonFont leftButtonTitle:@"取消" leftButtonTitleColor:[ZHJAlertView appearance].leftButtonTitleColor leftButtonBackgroundColor:[ZHJAlertView appearance].leftButtonBackgroundColor rightButtonTitle:@"确定" rightButtonTitleColor:[ZHJAlertView appearance].rightButtonTitleColor rightButtonBackgroundColor:[ZHJAlertView appearance].rightButtonBackgroundColor cornerRadius:[ZHJAlertView appearance].cornerRadius];
}

- (instancetype)initWithFrame:(CGRect)frame {
	return [self initWithMarginVertical:[ZHJAlertView appearance].marginVertical paddingTop:[ZHJAlertView appearance].paddingTop paddingVertical:[ZHJAlertView appearance].paddingVertical image:nil imageSize:CGSizeZero imageBottom:[ZHJAlertView appearance].imageBottom title:@"" titleFont:[ZHJAlertView appearance].titleFont titleColor:[ZHJAlertView appearance].titleColor titleBottom:[ZHJAlertView appearance].titleBottom content:@"" contentFont:[ZHJAlertView appearance].contentFont contentColor:[ZHJAlertView appearance].contentColor contentBottom:[ZHJAlertView appearance].contentBottom lineColor:[ZHJAlertView appearance].lineColor buttonHeight:[ZHJAlertView appearance].buttonHeight buttonFont:[ZHJAlertView appearance].buttonFont leftButtonTitle:@"取消" leftButtonTitleColor:[ZHJAlertView appearance].leftButtonTitleColor leftButtonBackgroundColor:[ZHJAlertView appearance].leftButtonBackgroundColor rightButtonTitle:@"确定" rightButtonTitleColor:[ZHJAlertView appearance].rightButtonTitleColor rightButtonBackgroundColor:[ZHJAlertView appearance].rightButtonBackgroundColor cornerRadius:[ZHJAlertView appearance].cornerRadius];
}

#pragma mark - <NSCoding>
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		_marginVertical = [aDecoder decodeFloatForKey:@"_marginVertical"];
		_paddingTop = [aDecoder decodeFloatForKey:@"_paddingTop"];
		_paddingVertical = [aDecoder decodeFloatForKey:@"_paddingVertical"];
		
		_image = [aDecoder decodeObjectForKey:@"_image"];
		_imageSize = [aDecoder decodeCGSizeForKey:@"_imageSize"];
		_imageBottom = [aDecoder decodeFloatForKey:@"_imageBottom"];
		
		_title = [aDecoder decodeObjectForKey:@"_title"];
		_titleFont = [aDecoder decodeObjectForKey:@"_titleFont"];
		_titleColor = [aDecoder decodeObjectForKey:@"_titleColor"];
		_titleBottom = [aDecoder decodeFloatForKey:@"_titleBottom"];

		_content = [aDecoder decodeObjectForKey:@"_content"];
		_contentFont = [aDecoder decodeObjectForKey:@"_contentFont"];
		_contentColor = [aDecoder decodeObjectForKey:@"_contentColor"];
		_contentBottom = [aDecoder decodeFloatForKey:@"_contentBottom"];
		
		_lineColor = [aDecoder decodeObjectForKey:@"_lineColor"];
		
		_buttonHeight = [aDecoder decodeFloatForKey:@"_buttonHeight"];
		_buttonFont = [aDecoder decodeObjectForKey:@"_buttonFont"];
		
		_leftButtonTitle = [aDecoder decodeObjectForKey:@"_leftButtonTitle"];
		_leftButtonTitleColor = [aDecoder decodeObjectForKey:@"_leftButtonTitleColor"];
		_leftButtonBackgroundColor = [aDecoder decodeObjectForKey:@"_leftButtonBackgroundColor"];
		
		_rightButtonTitle = [aDecoder decodeObjectForKey:@"_rightButtonTitle"];
		_rightButtonTitleColor = [aDecoder decodeObjectForKey:@"_rightButtonTitleColor"];
		_rightButtonBackgroundColor = [aDecoder decodeObjectForKey:@"_rightButtonBackgroundColor"];
		
		_leftButtonClickBlock = [aDecoder decodeObjectForKey:@"_leftButtonClickBlock"];
		_rightButtonClickBlock = [aDecoder decodeObjectForKey:@"_rightButtonClickBlock"];
		
		_imageView = [aDecoder decodeObjectForKey:@"_imageView"];
		_titleLabel = [aDecoder decodeObjectForKey:@"_titleLabel"];
		_contentLabel = [aDecoder decodeObjectForKey:@"_contentLabel"];
		_line = [aDecoder decodeObjectForKey:@"_line"];
		_leftButton = [aDecoder decodeObjectForKey:@"_leftButton"];
		_rightButton = [aDecoder decodeObjectForKey:@"_rightButton"];
		
		_cornerRadius = [aDecoder decodeFloatForKey:@"_cornerRadius"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[super encodeWithCoder:aCoder];
	[aCoder encodeFloat:_marginVertical forKey:@"_marginVertical"];
	[aCoder encodeFloat:_paddingTop forKey:@"_paddingTop"];
	[aCoder encodeFloat:_paddingVertical forKey:@"_paddingVertical"];
	
	[aCoder encodeObject:_image forKey:@"_image"];
	[aCoder encodeCGSize:_imageSize forKey:@"_imageSize"];
	[aCoder encodeFloat:_imageBottom forKey:@"_imageBottom"];
	
	[aCoder encodeObject:_title forKey:@"_title"];
	[aCoder encodeObject:_titleFont forKey:@"_titleFont"];
	[aCoder encodeObject:_titleColor forKey:@"_titleColor"];
	[aCoder encodeFloat:_titleBottom forKey:@"_titleBottom"];
	
	[aCoder encodeObject:_content forKey:@"_content"];
	[aCoder encodeObject:_contentFont forKey:@"_contentFont"];
	[aCoder encodeObject:_contentColor forKey:@"_contentColor"];
	[aCoder encodeFloat:_contentBottom forKey:@"_contentBottom"];
	
	[aCoder encodeObject:_lineColor forKey:@"_lineColor"];
	
	[aCoder encodeFloat:_buttonHeight forKey:@"_buttonHeight"];
	[aCoder encodeObject:_buttonFont forKey:@"_buttonFont"];
	
	[aCoder encodeObject:_leftButtonTitle forKey:@"_leftButtonTitle"];
	[aCoder encodeObject:_leftButtonTitleColor forKey:@"_leftButtonTitleColor"];
	[aCoder encodeObject:_leftButtonBackgroundColor forKey:@"_leftButtonBackgroundColor"];
	
	[aCoder encodeObject:_rightButtonTitle forKey:@"_rightButtonTitle"];
	[aCoder encodeObject:_rightButtonTitleColor forKey:@"_rightButtonTitleColor"];
	[aCoder encodeObject:_rightButtonBackgroundColor forKey:@"_rightButtonBackgroundColor"];
	
	[aCoder encodeObject:_leftButtonClickBlock forKey:@"_leftButtonClickBlock"];
	[aCoder encodeObject:_rightButtonClickBlock forKey:@"_rightButtonClickBlock"];
	
	[aCoder encodeObject:_imageView forKey:@"_imageView"];
	[aCoder encodeObject:_titleLabel forKey:@"_titleLabel"];
	[aCoder encodeObject:_contentLabel forKey:@"_contentLabel"];
	[aCoder encodeObject:_line forKey:@"_line"];
	[aCoder encodeObject:_leftButton forKey:@"_leftButton"];
	[aCoder encodeObject:_rightButton forKey:@"_rightButton"];
	
	[aCoder encodeFloat:_cornerRadius forKey:@"_cornerRadius"];
}

#pragma mark -
- (void)layoutSubviews {
	[super layoutSubviews];
	
	[_imageView removeFromSuperview];
	[_titleLabel removeFromSuperview];
	[_contentLabel removeFromSuperview];
	[_line removeFromSuperview];
	[_leftButton removeFromSuperview];
	[_rightButton removeFromSuperview];
	
	CGSize size = self.bounds.size;
	CGFloat top = _paddingTop;
	
	//提示图片
	if (_image) {
		[self addSubview:self.imageView];
		self.imageView.frame = CGRectMake((size.width-_imageSize.width)/2, top, _imageSize.width, _imageSize.height);
		self.imageView.image = _image;
		top = self.imageView.bottom+_imageBottom;
	}
	
	//提示标题
	if (_title.length>0) {
		[self addSubview:self.titleLabel];
		self.titleLabel.frame = CGRectMake(_paddingVertical, top, size.width-_paddingVertical*2, _titleFont.pointSize);
		self.titleLabel.text = _title;
		self.titleLabel.font = _titleFont;
		self.titleLabel.textColor = _titleColor;
		top = self.titleLabel.bottom+_titleBottom;
	}
	
	//提示内容
	if (_content.length>0) {
		[self addSubview:self.contentLabel];
		CGFloat contenHeight = [_content boundingRectWithSize:CGSizeMake(size.width-_paddingVertical*2, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_contentFont.pointSize]} context:nil].size.height;
		self.contentLabel.frame = CGRectMake(_paddingVertical, top, size.width-_paddingVertical*2, contenHeight);
		self.contentLabel.text = _content;
		self.contentLabel.font = _contentFont;
		self.contentLabel.textColor = _contentColor;
		top = self.contentLabel.bottom+_contentBottom;
	}

	//横线
	[self addSubview:self.line];
	self.line.frame = CGRectMake(0, top, size.width, 0.5);
	self.line.backgroundColor = _lineColor;
	top += 0.5;
	
	if (self.leftButtonTitle.length>0 && self.rightButtonTitle.length>0) {
		//左按钮
		[self addSubview:self.leftButton];
		self.leftButton.frame = CGRectMake(0, top, size.width/2, _buttonHeight);
		[self.leftButton.titleLabel setFont:_buttonFont];
		[self.leftButton setTitle:_leftButtonTitle forState:UIControlStateNormal];
		[self.leftButton setTitleColor:_leftButtonTitleColor forState:UIControlStateNormal];
		[self.leftButton setBackgroundColor:_leftButtonBackgroundColor];
		
		//右按钮
		[self addSubview:self.rightButton];
		self.rightButton.frame = CGRectMake(size.width/2, top, size.width/2, _buttonHeight);
		[self.rightButton.titleLabel setFont:_buttonFont];
		[self.rightButton setTitle:_rightButtonTitle forState:UIControlStateNormal];
		[self.rightButton setTitleColor:_rightButtonTitleColor forState:UIControlStateNormal];
		[self.rightButton setBackgroundColor:_rightButtonBackgroundColor];
	}else if (self.rightButtonTitle.length>0) {
		//右按钮
		[self addSubview:self.rightButton];
		self.rightButton.frame = CGRectMake(0, top, size.width, _buttonHeight);
		[self.rightButton.titleLabel setFont:_buttonFont];
		[self.rightButton setTitle:_rightButtonTitle forState:UIControlStateNormal];
		[self.rightButton setTitleColor:_rightButtonTitleColor forState:UIControlStateNormal];
		[self.rightButton setBackgroundColor:_rightButtonBackgroundColor];
	}else if (self.leftButtonTitle.length>0) {
		//左按钮
		[self addSubview:self.leftButton];
		self.leftButton.frame = CGRectMake(0, top, size.width, _buttonHeight);
		[self.leftButton.titleLabel setFont:_buttonFont];
		[self.leftButton setTitle:_leftButtonTitle forState:UIControlStateNormal];
		[self.leftButton setTitleColor:_leftButtonTitleColor forState:UIControlStateNormal];
		[self.leftButton setBackgroundColor:_leftButtonBackgroundColor];
	}
	
	self.layer.cornerRadius = _cornerRadius;
	self.layer.masksToBounds = YES;
}

#pragma mark - Public Methods
- (void)showInViewController:(UIViewController *)viewController {
	CGFloat width = ZHJ_SCREEN_WIDTH-self.marginVertical*2;
	CGFloat height = self.paddingTop;
	if (_image) {
		height += self.imageSize.height+self.imageBottom;
	}
	if ([_title length]>0) {
		height += self.titleFont.pointSize+self.titleBottom;
	}
	if ([_content length]>0) {
		height += [self.content heightWithFontSize:self.contentFont.pointSize withinSize:CGSizeMake(width-self.paddingVertical*2, CGFLOAT_MAX)]+self.contentBottom;
	}
	height += self.buttonHeight;
	self.frame = CGRectMake((ZHJ_SCREEN_WIDTH-width)/2, (ZHJ_SCREEN_HEIGHT-height)/2, width, height);
	[ZHJ_POPUPS popupView:self inViewController:viewController backgroundColor:ZHJ_HEX_COLOR(0x000000, 0.3) animationType:ZHJPopupsAnimationFade completion:nil];
}

- (void)dismiss {
	[ZHJ_POPUPS dismissView:self animationType:ZHJPopupsAnimationNone completion:nil];
}

#pragma mark - Setter

#pragma mark - Event Response
- (void)leftButtonClick {
	if (self.leftButtonClickBlock) {
		self.leftButtonClickBlock();
	}
	[ZHJ_POPUPS dismissView:self animationType:ZHJPopupsAnimationNone completion:nil];
}

- (void)rightButtonClick {
	if (self.rightButtonClickBlock) {
		self.rightButtonClickBlock();
	}
	[ZHJ_POPUPS dismissView:self animationType:ZHJPopupsAnimationNone completion:nil];
}

#pragma mark - Getter
- (UIImageView *)imageView {
	if (!_imageView) {
		_imageView = [[UIImageView alloc] init];
	}
	return _imageView;
}

- (UILabel *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleLabel;
}

- (UILabel *)contentLabel {
	if (!_contentLabel) {
		_contentLabel = [[UILabel alloc] init];
		_contentLabel.textAlignment = NSTextAlignmentCenter;
		_contentLabel.numberOfLines = 0;
		_contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
	}
	return _contentLabel;
}

- (UIButton *)leftButton {
	if (!_leftButton) {
		_leftButton = [[UIButton alloc] init];
		_leftButton.tag = 1;
		[_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
	}
	return _leftButton;
}

- (UIButton *)rightButton {
	if (!_rightButton) {
		_rightButton = [[UIButton alloc] init];
		_rightButton.tag = 2;
		[_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
	}
	return _rightButton;
}

@end
