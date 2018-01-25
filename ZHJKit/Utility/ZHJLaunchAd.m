//
//  ZHJLaunchAd.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJLaunchAd.h"
#import "ZHJMarco.h"
#import "ZHJFactory.h"

#define kZHJFirstLaunchKey                @"kZHJFirstLaunchKey"
#define kZHJLaunchFinishKey               @"kZHJLaunchFinishKey"

@interface ZHJLaunchAd()<UIScrollViewDelegate>
@property (nonatomic, strong) UIWindow *launchWindow;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation ZHJLaunchAd

static ZHJLaunchAd *_launchAd;

#pragma mark - Initialization
+ (void)load {
    [self sharedInstance];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _launchAd = [super allocWithZone:NULL];
    });
    return _launchAd;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _launchAd = [[self alloc] init];
    });
    return _launchAd;
}

- (id)copyWithZone:(NSZone *)zone {
    return _launchAd;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _launchAd;
}

- (instancetype)init {
    if (self = [super init]) {

        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
            NSNumber *firstLaunch = [ZHJ_USER_DEFAULTS objectForKey:kZHJFirstLaunchKey];
            if ([firstLaunch integerValue]<2) {
                [self checkAd];
            }
        }];

        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
            // [self getAd];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
            // [self checkAd];
        }];
        
        self.imageCount = 0;
        
        for (NSInteger i=0; i<8; i++) {
            NSString *imageName = [NSString stringWithFormat:@"HJLaunch-%01ld", (long)i+1];
            UIImage *image = [UIImage imageNamed:imageName];
            if (!image) {
                return self;
            }
            self.imageCount++;
        }
    }
    return self;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

#pragma mark - Event Response
- (void)btnTap:(UIButton *)btn {
    if (btn.tag==self.imageCount) {
        [ZHJ_USER_DEFAULTS setObject:@2 forKey:kZHJFirstLaunchKey];
        [self hide];
    }
}

#pragma mark - Private Methods
- (void)getAd {
}

- (void)checkAd {
    [self show];
}

- (void)show {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    [self setupSubviews:window];
    
    window.windowLevel = UIWindowLevelStatusBar + 1;
    
    window.hidden = NO;
    window.alpha = 1;
    
    self.launchWindow = window;
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.launchWindow.alpha = 0;
    } completion:^(BOOL finished) {
        self.launchWindow.hidden = YES;
        self.launchWindow = nil;
    }];
}

- (void)setupSubviews:(UIWindow*)window {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(self.imageCount*ZHJ_SCREEN_WIDTH, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    for (NSInteger i=0; i<self.imageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"HJLaunch-%01ld", (long)i+1];
        UIButton *btn = [HJFactory buttonFrame:CGRectMake(i*ZHJ_SCREEN_WIDTH, 0, ZHJ_SCREEN_WIDTH, ZHJ_SCREEN_HEIGHT) title:@"" fontSize:0 titleColor:nil image:ZHJ_IMAGE(imageName) bgColor:[UIColor whiteColor]];
        btn.backgroundColor = i==0 ? [UIColor whiteColor] : ZHJ_HEXCOLOR(0xFEFDE0, 1.0);
        btn.tag = i+1;
        [btn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
    }
    [window addSubview:scrollView];
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, ZHJ_SCREEN_HEIGHT-30-ZHJ_TABBAR_HEIGHT+49, ZHJ_SCREEN_WIDTH, 20)];
    pageControl.numberOfPages = self.imageCount;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [window addSubview:pageControl];
    self.pageControl = pageControl;
}

@end
