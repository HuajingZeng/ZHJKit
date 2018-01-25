//
//  ZHJGestureUnlockView.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHJGestureUnlockView;
@protocol ZHJGestureUnlockViewDelegate <NSObject>
- (void)gestureFinished:(NSString *)password;
@end

@interface ZHJGestureUnlockView : UIView

@property (nonatomic, weak) id<ZHJGestureUnlockViewDelegate> delegate;
@property (nonatomic, assign) CGFloat buttonSize;
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;


- (instancetype)initWithFrame:(CGRect)frame buttonSize:(CGFloat)buttonSize space:(CGFloat)space image:(UIImage *)image selectedImage:(UIImage *)selectedImage lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:buttonSize:space:borderWidth:image:selectedImage:lineWidth:lineColor:");
- (instancetype)initWithFrame:(CGRect)frame NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:buttonSize:space:borderWidth:image:selectedImage:lineWidth:lineColor:");

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (void)encodeWithCoder:(NSCoder *)aCoder;
@end
