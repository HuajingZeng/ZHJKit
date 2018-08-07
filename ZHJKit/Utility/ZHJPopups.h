//
//  ZHJPopups.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (ZHJPopups)
- (UIViewController *)presentedRootViewController;
@end

#define ZHJ_POPUPS      ([ZHJPopups sharedInstance])

/**
 Popup animation effects
 */
typedef NS_ENUM(NSInteger, ZHJPopupsAnimationType){
    ZHJPopupsAnimationNone,// No animation（Default）
    ZHJPopupsAnimationFade,// Transparency gradient
    ZHJPopupsAnimationScale,// Zoom
    ZHJPopupsAnimationScaleAndFade,// Zoom and transparency gradient
    ZHJPopupsAnimationTranslateFromBottom,// Move from bottom of screen
    ZHJPopupsAnimationTranslateToBottom,// Remove from bottom of screen
    ZHJPopupsAnimationTranslateFromTop,// Move from top of screen
    ZHJPopupsAnimationTranslateToTop,// Remove from top of screen
    ZHJPopupsAnimationTranslateFromLeft,// Move from left of screen
    ZHJPopupsAnimationTranslateToLeft,// Remove from left of screen
    ZHJPopupsAnimationTranslateFromRight,// Move from right of screen
    ZHJPopupsAnimationTranslateToRight,// Remove from right of screen
};

@interface ZHJPopups : NSObject
/**
 Get singleton
 */
+ (instancetype)sharedInstance;

/**
 Popup
 */
- (void)popupView:(UIView *)view inViewController:(UIViewController *)viewController backgroundColor:(UIColor *)backgroundColor animationType:(ZHJPopupsAnimationType)animationType completion:(void(^)(void))completion;
- (void)popupView:(UIView *)view inViewController:(UIViewController *)viewController backgroundColor:(UIColor *)backgroundColor animationType:(ZHJPopupsAnimationType)animationType completion:(void(^)(void))completion tapOutsideToDismiss:(BOOL)tap dismissCompletion:(void(^)(void))dismissCompletion;

/**
 Dismiss
 */
- (void)dismissView:(UIView *)view animationType:(ZHJPopupsAnimationType)animationType completion:(void(^)(void))completion;
- (void)dismissAll;

/**
 Message
 */
- (void)showMessage:(NSString *)text inViewController:(UIViewController *)viewController duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void(^)(void))completion;
- (void)showMessage:(NSString *)text inViewController:(UIViewController *)viewController completion:(void(^)(void))completion;

@end
