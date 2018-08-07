//
//  ZHJPhotoBrowser.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJPhotoBrowser.h"
#import "ZHJMarco.h"
#import "ZHJPopups.h"

@interface ZHJPhotoModel()
@property (nonatomic, assign) NSUInteger index;
@end
@implementation ZHJPhotoModel
@end


#pragma mark - ZHJPhotoView
#define kZHJPhotoViewMaxZoomScale 2.0
#define kZHJPhotoViewMinZoomScale 1.0
@class ZHJPhotoView;
@protocol ZHJPhotoViewDelegate <NSObject>
- (void)photoViewImageStartLoad:(ZHJPhotoView *)photoView;
- (void)photoViewImageFinishLoad:(ZHJPhotoView *)photoView;
- (void)photoViewSingleTap:(ZHJPhotoView *)photoView;
@end
@interface ZHJPhotoView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) id<ZHJPhotoViewDelegate> photoViewDelegate;
@property (nonatomic, strong) ZHJPhotoModel *photo;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL zoomByDoubleTap;
@end
@implementation ZHJPhotoView
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

- (void)configImageViewWithImage:(UIImage *)image{
    _imageView.image = image;
}

- (void)setPhoto:(ZHJPhotoModel *)photo {
    _photo = photo;
    [self showImage];
}

- (void)showImage {
    [self photoStartLoad];
    [self adjustFrame];
}

- (void)photoStartLoad {
    if (_photo.image) {
        _imageView.image = self.photo.image;
        self.scrollEnabled = YES;
    }else {
        _imageView.image = self.photo.placeHolder;
        self.scrollEnabled = NO;
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageStartLoad:)]) {
            [self.photoViewDelegate photoViewImageStartLoad:self];
        }
        /*
        HJ_WEAK_SELF(self);
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.photo.url] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageHandleCookies progress:nil completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            STRONG_SELF(self);
            [self photoDidFinishLoadWithImage:image];
        }];
         */
    }
}

- (void)photoDidFinishLoadWithImage:(UIImage *)image {
    if (image) {
        self.scrollEnabled = YES;
        _imageView.image = image;
        _photo.image = image;
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        _imageView.image = self.photo.placeHolder;
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [ZHJ_POPUPS showMessage:@"图片加载失败" inViewController:rootViewController completion:nil];
    }
    [self adjustFrame];
}

- (void)adjustFrame {
    if (_imageView.image == nil) return;
    
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGFloat imageWidth = _imageView.image.size.width;
    CGFloat imageHeight = _imageView.image.size.height;
    
    CGFloat imageScale = boundsWidth / imageWidth;
    CGFloat minScale = MIN(kZHJPhotoViewMinZoomScale, imageScale);
    CGFloat maxScale = kZHJPhotoViewMaxZoomScale;
    
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, MAX(0, (boundsHeight- imageHeight*imageScale)/2), boundsWidth, imageHeight *imageScale);
    self.contentSize = CGSizeMake(CGRectGetWidth(imageFrame), CGRectGetHeight(imageFrame));
    _imageView.frame = imageFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (_zoomByDoubleTap) {
        CGFloat insetY = (CGRectGetHeight(self.bounds) - CGRectGetHeight(_imageView.frame))/2;
        insetY = MAX(insetY, 0.0);
        if (ABS(_imageView.frame.origin.y - insetY) > 0.5) {
            CGRect imageViewFrame = _imageView.frame;
            imageViewFrame = CGRectMake(imageViewFrame.origin.x, insetY, imageViewFrame.size.width, imageViewFrame.size.height);
            _imageView.frame = imageViewFrame;
        }
    }
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    _zoomByDoubleTap = NO;
    CGFloat insetY = (CGRectGetHeight(self.bounds) - CGRectGetHeight(_imageView.frame))/2;
    insetY = MAX(insetY, 0.0);
    if (ABS(_imageView.frame.origin.y - insetY) > 0.5) {
        ZHJ_WEAK_OBJ(self);
        [UIView animateWithDuration:0.2 animations:^{
            ZHJ_STRONG_OBJ(self);
            CGRect imageViewFrame = self.imageView.frame;
            imageViewFrame = CGRectMake(imageViewFrame.origin.x, insetY, imageViewFrame.size.width, imageViewFrame.size.height);
            self.imageView.frame = imageViewFrame;
        }];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
        [self.photoViewDelegate photoViewSingleTap:self];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _zoomByDoubleTap = YES;
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self];
        CGFloat scale = self.maximumZoomScale/ self.zoomScale;
        CGRect rectTozoom=CGRectMake(touchPoint.x * scale, touchPoint.y * scale, 1, 1);
        [self zoomToRect:rectTozoom animated:YES];
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)dealloc {
    _imageView.image = ZHJ_IMAGE(@"Placeholder");
}

@end

#pragma mark - ZHJPhotoBrowser
#define kZHJPhotoBrowserPadding 0
@interface ZHJPhotoBrowser ()<UIScrollViewDelegate, ZHJPhotoViewDelegate>
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableSet *visiblePhotoViews, *reusablePhotoViews;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIButton *btn;
@end
@implementation ZHJPhotoBrowser

- (void)show {
    if (_photos.count==0) {
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [ZHJ_POPUPS showMessage:@"无图片" inViewController:rootViewController completion:nil];
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    CGRect frame = self.view.bounds;
    frame.origin.x -= kZHJPhotoBrowserPadding;
    frame.size.width += (2*kZHJPhotoBrowserPadding);
    self.scrollView.contentSize = CGSizeMake(frame.size.width*self.photos.count, 0);
    self.scrollView.contentOffset = CGPointMake(self.currentIndex*frame.size.width, 0);
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.indexLabel];
    [self.view addSubview:self.btn];
    [self updateIndexLabel];
    [self showPhotos];
    
    self.view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

- (void)showPhotos {
    CGRect visibleBounds = _scrollView.bounds;
    int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kZHJPhotoBrowserPadding*2) / CGRectGetWidth(visibleBounds));
    int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kZHJPhotoBrowserPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = (int)_photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = (int)_photos.count - 1;
    
    //回收不再显示的PhotoView
    NSInteger photoViewIndex;
    for (ZHJPhotoView *photoView in self.visiblePhotoViews) {
        photoViewIndex = photoView.tag-1000;
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [self.reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }
    
    [self.visiblePhotoViews minusSet:self.reusablePhotoViews];
    while (self.reusablePhotoViews.count > 2) {
        [self.reusablePhotoViews removeObject:[self.reusablePhotoViews anyObject]];
    }
    
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
}

- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (ZHJPhotoView *photoView in self.visiblePhotoViews) {
        if (index == photoView.tag-1000) {
            return YES;
        }
    }
    return NO;
}

- (void)showPhotoViewAtIndex:(NSUInteger)index {
    ZHJPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) {
        photoView = [[ZHJPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    
    CGRect bounds = _scrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2*kZHJPhotoBrowserPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kZHJPhotoBrowserPadding;
    photoView.tag = index+1000;
    
    ZHJPhotoModel *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [self.visiblePhotoViews addObject:photoView];
    [_scrollView addSubview:photoView];
    [self loadImageNearIndex:index];
}

- (ZHJPhotoView *)dequeueReusablePhotoView {
    ZHJPhotoView *photoView = [self.reusablePhotoViews anyObject];
    if (photoView) {
        [self.reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}

- (void)loadImageNearIndex:(NSUInteger)index {
    if (index > 0) {
        ZHJPhotoModel *photo = _photos[index-1];
        if (self.loadNearImageBlock) {
            self.loadNearImageBlock([NSURL URLWithString:photo.url]);
        }
    }
    
    if (index < self.photos.count-1) {
        ZHJPhotoModel *photo = _photos[index+1];
        if (self.loadNearImageBlock) {
            self.loadNearImageBlock([NSURL URLWithString:photo.url]);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showPhotos];
    [self updateIndexLabel];
}

- (void)updateIndexLabel {
    _currentIndex = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    if (self.photos.count>1) {
        self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.currentIndex+1, (long)self.photos.count];
    }else {
        self.indexLabel.text = @"";
    }
}

- (void)photoViewSingleTap:(ZHJPhotoView *)photoView {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.indexLabel removeFromSuperview];
    [self.btn removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)photoViewImageStartLoad:(ZHJPhotoView *)photoView {
    if (self.loadCurrentImageBlock) {
        self.loadCurrentImageBlock(photoView.imageView, [NSURL URLWithString:photoView.photo.url]);
    }else {
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [ZHJ_POPUPS showMessage:@"图片加载失败" inViewController:rootViewController completion:nil];
        photoView.imageView.image = ZHJ_IMAGE(@"Placeholder");
    }
}

- (void)photoViewImageFinishLoad:(ZHJPhotoView *)photoView {
    [self updateIndexLabel];
}

- (void)btnTap {
    if (self.buttonType==ZHJPhotoBrowserButtonTypeDelete) {
        if (self.deleteImageBlock) {
            self.deleteImageBlock(self.currentIndex);
        }
        if (self.photos.count>1) {
            [self.photos removeObjectAtIndex:self.currentIndex];
            self.currentIndex = self.currentIndex<self.photos.count-1 ? self.currentIndex : self.photos.count-1;
            [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            CGRect frame = self.view.bounds;
            frame.origin.x -= kZHJPhotoBrowserPadding;
            frame.size.width += (2*kZHJPhotoBrowserPadding);
            self.scrollView.contentSize = CGSizeMake(frame.size.width*self.photos.count, 0);
            self.visiblePhotoViews = nil;
            self.reusablePhotoViews = nil;
            [self showPhotos];
            [self updateIndexLabel];
        }else {
            [self photoViewSingleTap:nil];
        }
    }else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ZHJPhotoModel *photo = self.photos[self.currentIndex];
            UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (error) {
        [ZHJ_POPUPS showMessage:@"保存失败" inViewController:rootViewController completion:nil];
    } else {
        [ZHJ_POPUPS showMessage:@"保存成功" inViewController:rootViewController completion:nil];
    }
}

- (void)setPhotos:(NSMutableArray<ZHJPhotoModel *> *)photos {
    _photos = photos;
    if (_photos.count<=0) {
        return;
    }
    for (int i=0; i<_photos.count; i++) {
        ZHJPhotoModel *photo = _photos[i];
        photo.index = i;
    }
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    if (_scrollView) {
        _scrollView.contentOffset = CGPointMake(_currentIndex * _scrollView.frame.size.width, 0);
        [self showPhotos];
    }
}

- (void)setHideBtn:(BOOL)hideBtn {
    _hideBtn = hideBtn;
    [_btn setHidden:_hideBtn];
}

- (UIView *)view{
    if (!_view) {
        _view = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        _view.backgroundColor = [UIColor blackColor];
    }
    return _view;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGRect frame = self.view.bounds;
        frame.origin.x -= kZHJPhotoBrowserPadding;
        frame.size.width += (2*kZHJPhotoBrowserPadding);
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (NSMutableSet *)visiblePhotoViews {
    if (!_visiblePhotoViews) {
        _visiblePhotoViews = [NSMutableSet set];
    }
    return _visiblePhotoViews;
}

- (NSMutableSet *)reusablePhotoViews {
    if (!_reusablePhotoViews) {
        _reusablePhotoViews = [NSMutableSet set];
    }
    return _reusablePhotoViews;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ZHJ_SCREEN_HEIGHT-ZHJ_TABBAR_HEIGHT+49-10-15, ZHJ_SCREEN_WIDTH, 15)];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.font = [UIFont systemFontOfSize:15];
        _indexLabel.textColor = [UIColor whiteColor];
    }
    return _indexLabel;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(ZHJ_SCREEN_WIDTH-60, ZHJ_SCREEN_HEIGHT-ZHJ_TABBAR_HEIGHT+49-35, 50, 35)];
        _btn.hidden = self.hideBtn;
        ZHJ_VIEW_RADIUS_BORDER(_btn, 5, 0.5, [UIColor whiteColor]);
        [_btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSString *btnTitle = self.buttonType==ZHJPhotoBrowserButtonTypeDelete ? @"删除" : @"保存";
        [_btn setTitle:btnTitle forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

@end
