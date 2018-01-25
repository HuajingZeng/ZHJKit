//
//  ZHJPopups.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJPopups.h"
#import "ZHJMarco.h"

@interface ZHJPopups()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, copy) void (^dismissCompletion)(void);
@property (nonatomic, strong) UIView *alertView;
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
    if (touch.view != _maskView) {
        return NO;
    }
    return YES;
}

#pragma mark - Public Methods
- (void)popupView:(UIView *)view backgroundColor:(UIColor *)backgroundColor animationType:(ZHJPopupsAnimationType)animationType completion:(void (^)(void))completion {
    [self popupView:view backgroundColor:backgroundColor animationType:animationType completion:completion showCloseBtn:NO tapOutsideToDismiss:NO dismissCompletion:nil];
}

- (void)popupView:(UIView *)view backgroundColor:(UIColor *)backgroundColor animationType:(ZHJPopupsAnimationType)animationType completion:(void (^)(void))completion showCloseBtn:(BOOL)show tapOutsideToDismiss:(BOOL)tap dismissCompletion:(void (^)(void))dismissCompletion{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!weakSelf) return;
        __typeof (&*self) strongSelf = weakSelf;
        strongSelf.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT)];
        strongSelf.maskView.backgroundColor = backgroundColor;
        strongSelf.view = view;
        [strongSelf.maskView addSubview:strongSelf.view];
        [ZHJ_APP.keyWindow addSubview:strongSelf.maskView];
        if (show) {
            UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-24, 0, 24, 24)];
            [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(_dismiss) forControlEvents:UIControlEventTouchUpInside];
            strongSelf.dismissCompletion = dismissCompletion;
            [view addSubview:closeBtn];
        }
        
        if (tap){
            strongSelf.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismiss)];
            strongSelf.tap.delegate = self;
            strongSelf.dismissCompletion = dismissCompletion;
            [ZHJ_APP.keyWindow addGestureRecognizer:strongSelf.tap];
        }
        
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
                strongSelf.maskView.alpha = 0;
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.alpha = 1;
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationScale:
            {
                strongSelf.maskView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.transform = CGAffineTransformIdentity;;
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationScaleAndFade:
            {
                strongSelf.maskView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
                strongSelf.maskView.alpha = 0;
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.transform = CGAffineTransformIdentity;;
                    strongSelf.maskView.alpha = 1;
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateFromBottom:
            {
                strongSelf.maskView.frame = CGRectMake(0, ZHJ_SCREEN_HEIGHT, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.5 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.frame = CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateFromTop:
            {
                strongSelf.maskView.frame = CGRectMake(0, -ZHJ_SCREEN_HEIGHT, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.5 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.frame = CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateFromLeft:
            {
                strongSelf.maskView.frame = CGRectMake(-ZHJ_SCREEN_WIDTH, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.5 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.frame = CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateFromRight:
            {
                strongSelf.maskView.frame = CGRectMake(ZHJ_SCREEN_WIDTH, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.5 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.frame = CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
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

- (void)dismissView:(ZHJPopupsAnimationType)animationType completion:(void (^)(void))completion{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!weakSelf) return;
        __typeof (&*self) strongSelf = weakSelf;
        switch (animationType) {
            case ZHJPopupsAnimationNone:
            {
                [strongSelf.maskView removeFromSuperview];
                if (completion) {
                    completion();
                }
                break;
            }
                
            case ZHJPopupsAnimationFade:
            {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.alpha = 0;
                } completion:^(BOOL finished) {
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    [strongSelf.maskView removeFromSuperview];
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationScale:
            {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
                } completion:^(BOOL finished) {
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    [strongSelf.maskView removeFromSuperview];
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationScaleAndFade:
            {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.transform = CGAffineTransformMakeScale(CGFLOAT_MIN, CGFLOAT_MIN);
                    strongSelf.maskView.alpha = 0;
                } completion:^(BOOL finished) {
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    [strongSelf.maskView removeFromSuperview];
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateToBottom:
            {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.5 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.frame = CGRectMake(0, ZHJ_SCREEN_HEIGHT, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateToTop:
            {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.5 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.frame = CGRectMake(0, -ZHJ_SCREEN_HEIGHT, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateToLeft:
            {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.5 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.frame = CGRectMake(-ZHJ_SCREEN_WIDTH, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    if (completion) {
                        completion();
                    }
                }];
                break;
            }
                
            case ZHJPopupsAnimationTranslateToRight:
            {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.5 animations:^{
                    if (!weakSelf) return;
                    __typeof (&*self) strongSelf = weakSelf;
                    strongSelf.maskView.frame = CGRectMake(ZHJ_SCREEN_WIDTH, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT);
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
        
        if (strongSelf.tap) {
            [ZHJ_APP.keyWindow removeGestureRecognizer:strongSelf.tap];
            strongSelf.tap = nil;
        }
    });
}

- (void)showMessage:(NSString *)text duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void (^)(void))completion {
    [ZHJ_APP.keyWindow endEditing:YES];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!weakSelf) return;
        __typeof (&*self) strongSelf = weakSelf;
        strongSelf.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ZHJ_SCREEN_WIDTH/2, ZHJ_SCREEN_HEIGHT)];
        strongSelf.messageLabel.numberOfLines = 0;
        strongSelf.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        strongSelf.messageLabel.textAlignment = NSTextAlignmentCenter;
        strongSelf.messageLabel.textColor = [UIColor whiteColor];
        strongSelf.messageLabel.font = [UIFont boldSystemFontOfSize:15];
        strongSelf.messageLabel.text = text;
        [strongSelf.messageLabel sizeToFit];
        
        strongSelf.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, strongSelf.messageLabel.frame.size.width+40, strongSelf.messageLabel.frame.size.height+40)];
        strongSelf.alertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        strongSelf.alertView.layer.cornerRadius = 5;
        strongSelf.alertView.layer.masksToBounds = YES;
        strongSelf.alertView.center = CGPointMake(ZHJ_SCREEN_WIDTH/2, ZHJ_SCREEN_HEIGHT/2);
        strongSelf.messageLabel.center = CGPointMake(strongSelf.alertView.frame.size.width/2, strongSelf.alertView.frame.size.height/2);
        [strongSelf.alertView addSubview:strongSelf.messageLabel];
        [ZHJ_APP.keyWindow addSubview:strongSelf.alertView];
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (!weakSelf) return;
            __typeof (&*self) strongSelf = weakSelf;
            strongSelf.alertView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (!weakSelf) return;
            __typeof (&*self) strongSelf = weakSelf;
            [strongSelf.alertView removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    });
}

- (void)showMessage:(NSString *)text completion:(void (^)(void))completion {
    [self showMessage:text duration:1.5 delay:0.0 completion:completion];
}

#pragma mark - Private Methods
- (void)_dismiss {
    [self dismissView:ZHJPopupsAnimationFade completion:_dismissCompletion];
}

@end
