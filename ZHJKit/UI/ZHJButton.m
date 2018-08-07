//
//  ZHJButton.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJButton.h"

@interface ZHJButton ()

@end

@implementation ZHJButton

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame imageDirection:(ZHJButtonImageDirection)direction space:(CGFloat)space titleSize:(CGSize)titleSize iamgeSize:(CGSize)imageSize {
    if (self = [super initWithFrame:frame]) {
        _imageDirection = direction;
        _space = space;
        _titleSize = titleSize;
        _imageSize = imageSize;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageDirection:(ZHJButtonImageDirection)direction space:(CGFloat)space {
    return [self initWithFrame:frame imageDirection:direction space:space titleSize:CGSizeZero iamgeSize:CGSizeZero];
}

- (instancetype)initWithFrame:(CGRect)frame imageDirection:(ZHJButtonImageDirection)direction {
    return [self initWithFrame:frame imageDirection:direction space:0 titleSize:CGSizeZero iamgeSize:CGSizeZero];
}

- (instancetype)initWithFrame:(CGRect)frame space:(CGFloat)space {
    return [self initWithFrame:frame imageDirection:ZHJButtonImageDirectionDefault space:space titleSize:CGSizeZero iamgeSize:CGSizeZero];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero imageDirection:ZHJButtonImageDirectionDefault space:0 titleSize:CGSizeZero iamgeSize:CGSizeZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame imageDirection:ZHJButtonImageDirectionDefault space:0 titleSize:CGSizeZero iamgeSize:CGSizeZero];
}

#pragma mark - <NSCoding>
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _imageDirection = [aDecoder decodeIntegerForKey:@"_imageDirection"];
        _space = [aDecoder decodeFloatForKey:@"_space"];
        _titleSize = [aDecoder decodeCGSizeForKey:@"_titleSize"];
        _imageSize = [aDecoder decodeCGSizeForKey:@"_imageSize"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:_imageDirection forKey:@"_imageDirection"];
    [aCoder encodeFloat:_space forKey:@"_space"];
    [aCoder encodeCGSize:_titleSize forKey:@"_titleSize"];
    [aCoder encodeCGSize:_imageSize forKey:@"_imageSize"];
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGSize imageSize = _imageSize;
    if (_imageSize.width==0 && _imageSize.height==0) {
        imageSize = self.imageView.image.size;
    }
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGSize titleSize = _titleSize;
    if (_titleSize.width==0 && _titleSize.height==0) {
        titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    }
    CGFloat titleWidth = titleSize.width;
    CGFloat titleHeight = self.titleLabel.font.pointSize;
    
    switch (_imageDirection) {
        case ZHJButtonImageDirectionLeft:
        {
            [self.imageView setFrame:CGRectMake((width-imageWidth-_space-titleWidth)/2, (height-imageHeight)/2, imageWidth, imageHeight)];
            
            [self.titleLabel setFrame:CGRectMake(self.imageView.frame.origin.x+imageWidth+_space, (height-titleHeight)/2, titleWidth, titleHeight)];
            break;
        }
            
        case ZHJButtonImageDirectionRight:
        {
            [self.titleLabel setFrame:CGRectMake((width-titleWidth-_space-imageWidth)/2, (height-titleHeight)/2, titleWidth, titleHeight)];
            
            [self.imageView setFrame:CGRectMake(self.titleLabel.frame.origin.x+titleWidth+_space, (height-imageHeight)/2, imageWidth, imageHeight)];
            break;
        }
            
        case ZHJButtonImageDirectionTop:
        {
            [self.imageView setFrame:CGRectMake((width-imageWidth)/2, (height-imageHeight-_space-titleHeight)/2, imageWidth, imageHeight)];
            
            [self.titleLabel setFrame:CGRectMake(0, self.imageView.frame.origin.y+imageHeight+_space, width, titleHeight)];
            [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
            break;
        }
            
        case ZHJButtonImageDirectionBottom:
        {
            [self.titleLabel setFrame:CGRectMake(0, (height-titleHeight-_space-imageHeight)/2, width, titleHeight)];
            [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            [self.imageView setFrame:CGRectMake((width-imageWidth)/2, self.titleLabel.frame.origin.y+titleHeight+_space, imageWidth, imageHeight)];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


@end
