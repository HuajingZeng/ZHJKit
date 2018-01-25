//
//  ZHJHJDropDownMenuBar.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHJDropDownMenuBar;
@protocol ZHJDropDownMenuBarDelegate <NSObject>

@optional
- (void)menuBar:(ZHJDropDownMenuBar *)menuBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface ZHJDropDownMenuBar : UIView

@property (nonatomic, weak) id <ZHJDropDownMenuBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                numberOfItems:(NSInteger)number
                     delegate:(id)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame numberOfItems:(NSInteger)number;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

- (instancetype)init NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:menuTitles:target:action:");
- (instancetype)initWithFrame:(CGRect)frame NS_EXTENSION_UNAVAILABLE("Use -initWithFrame:menuTitles:target:action:");

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (void)encodeWithCoder:(NSCoder *)aCoder;

- (void)setItemTitleFont:(UIFont *)font;
- (void)setItemTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setItemTitles:(NSArray<NSString *> *)titles forState:(UIControlState)state;
- (void)setItemImage:(UIImage *)image forState:(UIControlState)state;
- (void)setItemImages:(NSArray<UIImage *> *)images forState:(UIControlState)state;

- (void)selectItemAtIndex:(NSInteger)index;

@end
