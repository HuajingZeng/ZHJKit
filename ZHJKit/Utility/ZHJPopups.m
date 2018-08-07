//
//  ZHJPopups.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJPopups.h"
#import "ZHJMarco.h"

@implementation UIApplication (ZHJPopups)

- (UIViewController *)presentedRootViewController {
    return [self presentedRootViewControllerWithRootViewController:self.keyWindow.rootViewController];
}

- (UIViewController *)presentedRootViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self presentedRootViewControllerWithRootViewController:presentedViewController];
    }else {
        return rootViewController;
    }
}

@end

@interface ZHJPopupsMaskView : UIButton
@end

@implementation ZHJPopupsMaskView
@end

#define k_ZHJPopups_ScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define k_ZHJPopups_ScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define k_ZHJPopups_App            ([UIApplication sharedApplication])


@interface ZHJPopups()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *maskViews;
@property (nonatomic, copy) void (^dismissCompletion)(void);
@property (nonatomic, strong) UIView *messageBackgroundView;
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation ZHJPopups

static ZHJPopups *_popups;

#pragma mark - Initialization
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _popups = [super allocWithZone:NULL];
    });
    return _popups;
}
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _popups = [[self alloc] init];
        _popups.maskViews = [NSMutableArray array];
    });
    return _popups;
}
- (id)copyWithZone:(NSZone *)zone {
    return _popups;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _popups;
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (![touch.view isKindOfClass:[ZHJPopupsMaskView class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - Public Methods
- (void)popupView:(UIView *)view inViewController:(UIViewController *)viewController backgroundColor:(UIColor *)backgroundColor animationType:(ZHJPopupsAnimationType)animationType completion:(void (^)(void))completion {
    [self popupView:view inViewController:(UIViewController *)viewController backgroundColor:backgroundColor animationType:animationType completion:completion showCloseBtn:NO tapOutsideToDismiss:NO dismissCompletion:nil];
}

- (void)popupView:(UIView *)view inViewController:(UIViewController *)viewController backgroundColor:(UIColor *)backgroundColor animationType:(ZHJPopupsAnimationType)animationType completion:(void (^)(void))completion showCloseBtn:(BOOL)show tapOutsideToDismiss:(BOOL)tap dismissCompletion:(void (^)(void))dismissCompletion{
    ZHJ_WEAK_OBJ(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        ZHJ_STRONG_OBJ(self);
        ZHJPopupsMaskView *maskView = [[ZHJPopupsMaskView alloc] initWithFrame:CGRectMake(0, 0, k_ZHJPopups_ScreenWidth, k_ZHJPopups_ScreenHeight)];
        maskView.backgroundColor = backgroundColor;
        [maskView addSubview:view];
        [viewController.view addSubview:maskView];
        
        if (show) {
            UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-24, 0, 24, 24)];
            [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(_dismiss) forControlEvents:UIControlEventTouchUpInside];
            self.dismissCompletion = dismissCompletion;
            [view addSubview:closeBtn];
        }
        
        if (tap){
            [maskView addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        ZHJ_WEAK_OBJ(maskView);
        switch (animationType) {
            case ZHJPopupsAnimationNone:
            {
                if (completion) {
                    completion();
                }
                break;
            }
                
            case ZHJPopupsAnimationFade:
            {
                maskView.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    ZHJ_STRONG_OBJ(maskView);
                    maskView.alpha = 1;
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationScale:
            {
                maskView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
                [UIView animateWithDuration:0.3 animations:^{
                    ZHJ_STRONG_OBJ(maskView);
                    maskView.transform = CGAffineTransformIdentity;;
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationScaleAndFade:
            {
                maskView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
                maskView.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    ZHJ_STRONG_OBJ(maskView);
                    maskView.transform = CGAffineTransformIdentity;;
                    maskView.alpha = 1;
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateFromBottom:
            {
                maskView.frame = CGRectMake(0, ZHJ_SCREEN_HEIGHT, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                [UIView animateWithDuration:0.5 animations:^{
                    ZHJ_STRONG_OBJ(maskView);
                    maskView.frame = CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateFromTop:
            {
                maskView.frame = CGRectMake(0, -ZHJ_SCREEN_HEIGHT, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                [UIView animateWithDuration:0.5 animations:^{
                    ZHJ_STRONG_OBJ(maskView);
                    maskView.frame = CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateFromLeft:
            {
                maskView.frame = CGRectMake(-ZHJ_SCREEN_WIDTH, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                [UIView animateWithDuration:0.5 animations:^{
                    ZHJ_STRONG_OBJ(maskView);
                    maskView.frame = CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateFromRight:
            {
                maskView.frame = CGRectMake(ZHJ_SCREEN_WIDTH, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                [UIView animateWithDuration:0.5 animations:^{
                    ZHJ_STRONG_OBJ(maskView);
                    maskView.frame = CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            default:
            {
                if (completion) {
                    completion();
                }
                break;
            }
        }
    });
}

- (void)dismiss:(ZHJPopupsMaskView *)maskView {
    [self dismissView:maskView animationType:ZHJPopupsAnimationNone completion:nil];
}

- (void)dismissView:(UIView *)view animationType:(ZHJPopupsAnimationType)animationType completion:(void (^)(void))completion{
    ZHJPopupsMaskView *maskView = nil;
    if ([view isKindOfClass:[ZHJPopupsMaskView class]]) {
        maskView = (ZHJPopupsMaskView *)view;
    }else if ([view.superview isKindOfClass:[ZHJPopupsMaskView class]]) {
        maskView = (ZHJPopupsMaskView *)view.superview;
    }
    
    if (maskView) {
        ZHJ_WEAK_OBJ(maskView);
        dispatch_async(dispatch_get_main_queue(), ^{
            ZHJ_STRONG_OBJ(maskView);
            ZHJ_WEAK_OBJ(maskView);
            switch (animationType) {
                case ZHJPopupsAnimationNone:
                {
                    [maskView removeFromSuperview];
                    if (completion) {
                        completion();
                    }
                    break;
                }
                    
                case ZHJPopupsAnimationFade:
                {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        maskView.alpha = 0;
                    } completion:^(BOOL finished) {
                        ZHJ_STRONG_OBJ(maskView);
                        [maskView removeFromSuperview];
                        if (completion) {
                            completion();
                        }
                    }];
                    break;
                }
                    
                case ZHJPopupsAnimationScale:
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        ZHJ_STRONG_OBJ(maskView);
                        maskView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
                    } completion:^(BOOL finished) {
                        ZHJ_STRONG_OBJ(maskView);
                        [maskView removeFromSuperview];
                        if (completion) {
                            completion();
                        }
                    }];
                    break;
                }
                    
                case ZHJPopupsAnimationScaleAndFade:
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        ZHJ_STRONG_OBJ(maskView);
                        maskView.transform = CGAffineTransformMakeScale(CGFLOAT_MIN, CGFLOAT_MIN);
                        maskView.alpha = 0;
                    } completion:^(BOOL finished) {
                        ZHJ_STRONG_OBJ(maskView);
                        [maskView removeFromSuperview];
                        if (completion) {
                            completion();
                        }
                    }];
                    break;
                }
                    
                case ZHJPopupsAnimationTranslateToBottom:
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        ZHJ_STRONG_OBJ(maskView);
                        maskView.frame = CGRectMake(0, ZHJ_SCREEN_HEIGHT, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                    } completion:^(BOOL finished) {
                        if (completion) {
                            completion();
                        }
                    }];
                    break;
                }
                    
                case ZHJPopupsAnimationTranslateToTop:
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        ZHJ_STRONG_OBJ(maskView);
                        maskView.frame = CGRectMake(0, -ZHJ_SCREEN_HEIGHT, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                    } completion:^(BOOL finished) {
                        if (completion) {
                            completion();
                        }
                    }];
                    break;
                }
                    
                case ZHJPopupsAnimationTranslateToLeft:
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        ZHJ_STRONG_OBJ(maskView);
                        maskView.frame = CGRectMake(-ZHJ_SCREEN_WIDTH, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                    } completion:^(BOOL finished) {
                        if (completion) {
                            completion();
                        }
                    }];
                    break;
                }
                    
                case ZHJPopupsAnimationTranslateToRight:
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        ZHJ_STRONG_OBJ(maskView);
                        maskView.frame = CGRectMake(ZHJ_SCREEN_WIDTH, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                    } completion:^(BOOL finished) {
                        if (completion) {
                            completion();
                        }
                    }];
                    break;
                }
                    
                default:
                {
                    if (completion) {
                        completion();
                    }
                    break;
                }
            }
            
            [self.maskViews removeObject:maskView];
        });
    }
}

- (void)dismissAll {
    for (ZHJPopupsMaskView *maskView in self.maskViews) {
        [self dismissView:maskView animationType:ZHJPopupsAnimationNone completion:nil];
    }
}

- (void)showMessage:(NSString *)text inViewController:(UIViewController *)viewController duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void (^)(void))completion {
    [k_ZHJPopups_App.keyWindow endEditing:YES];
    ZHJ_WEAK_OBJ(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        ZHJ_STRONG_OBJ(self);
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ZHJ_SCREEN_WIDTH/2, ZHJ_SCREEN_HEIGHT)];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.font = [UIFont boldSystemFontOfSize:15];
        self.messageLabel.text = text;
        [self.messageLabel sizeToFit];
        
        self.messageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.messageLabel.frame.size.width+40, self.messageLabel.frame.size.height+40)];
        self.messageBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        self.messageBackgroundView.layer.cornerRadius = 5;
        self.messageBackgroundView.layer.masksToBounds = YES;
        self.messageBackgroundView.center = CGPointMake(ZHJ_SCREEN_WIDTH/2, ZHJ_SCREEN_HEIGHT/2);
        self.messageLabel.center = CGPointMake(self.messageBackgroundView.frame.size.width/2, self.messageBackgroundView.frame.size.height/2);
        [self.messageBackgroundView addSubview:self.messageLabel];
        [ZHJ_APP.keyWindow addSubview:self.messageBackgroundView];
        
        ZHJ_WEAK_OBJ(self);
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            ZHJ_STRONG_OBJ(self);
            self.messageBackgroundView.alpha = 0.0;
        } completion:^(BOOL finished) {
            ZHJ_STRONG_OBJ(self);
            [self.messageBackgroundView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    });
}

- (void)showMessage:(NSString *)text inViewController:(UIViewController *)viewController completion:(void (^)(void))completion {
    [self showMessage:text inViewController:(UIViewController *)viewController duration:1.5 delay:0.0 completion:completion];
}

@end
