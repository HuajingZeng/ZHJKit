//
//  ZHJPhotoBrowser.h
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHJPhotoModel : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *placeHolder;
@end

typedef NS_ENUM(NSInteger, ZHJPhotoBrowserButtonType) {
    ZHJPhotoBrowserButtonTypeSave = 0,
    ZHJPhotoBrowserButtonTypeDelete = 1,
};

@interface ZHJPhotoBrowser : NSObject

@property (nonatomic, strong) NSMutableArray<ZHJPhotoModel *> *photos;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) BOOL hideBtn;
@property (nonatomic, assign) ZHJPhotoBrowserButtonType buttonType;
@property (nonatomic, copy) void (^loadCurrentImageBlock)(UIImageView *imageView, NSURL *url);
@property (nonatomic, copy) void (^loadNearImageBlock)(NSURL *url);
@property (nonatomic, copy) void (^deleteImageBlock)(NSUInteger index);

- (void)show;

@end
