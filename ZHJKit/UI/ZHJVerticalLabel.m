//
//  ZHJVerticalLabel.m
//  ZHJKit
//
//  Created by Kevin Zeng on 2018/1/24.
//  Copyright © 2018年 Huajing Zeng. All rights reserved.
//

#import "ZHJVerticalLabel.h"

@interface ZHJVerticalLabel()

@end

@implementation ZHJVerticalLabel

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text direction:(ZHJVerticalLabelWritingDirection)direction space:(CGFloat)space font:(UIFont *)font textColor:(UIColor *)textColor{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _writingDirection = direction;
        _space = space;
        self.text = text;
        self.font = font;
        self.textColor = textColor;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero text:@"" direction:ZHJVerticalLabelWritingDirectionLeftToRight space:0 font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame text:@"" direction:ZHJVerticalLabelWritingDirectionLeftToRight space:0 font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor]];
}

#pragma mark - <NSCoding>
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _writingDirection = [[aDecoder decodeObjectForKey:@"_writingDirection"] integerValue];
        _space = [[aDecoder decodeObjectForKey:@"_space"] floatValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:_writingDirection] forKey:@"_writingDirection"];
    [aCoder encodeObject:[NSNumber numberWithFloat:_space] forKey:@"_space"];
}

#pragma mark -
- (void)drawRect:(CGRect)rect {
    if (self.frame.size.width < self.font.pointSize) {
        return;
    }
    CGFloat x = 0;
    CGFloat y = 0;
    switch (_writingDirection) {
        case ZHJVerticalLabelWritingDirectionRightToLeft:
        {
            for (int i=0; i<self.text.length; i++) {
                NSString *str = [self.text substringWithRange:NSMakeRange(i, 1)];
                
                if (i==0) {
                    x = self.frame.size.width;
                }
                
                if ([str isEqualToString:@"\n"] || (y+self.font.pointSize > self.frame.size.height)) {
                    y = [str isEqualToString:@"\n"] ? 0 : self.font.pointSize;
                    if (x-_space-self.font.pointSize<0) {
                        break;
                    }else {
                        x = x - _space - self.font.pointSize;
                    }
                }else {
                    y += self.font.pointSize;
                }
                if ([str isEqualToString:@"\n"]) continue;
                [str drawInRect:CGRectMake(x-self.font.pointSize, y-self.font.pointSize*1.05, self.font.pointSize, self.font.pointSize*1.1) withAttributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.textColor}];
            }
            break;
        }
            
        case ZHJVerticalLabelWritingDirectionLeftToRight:
        {
            for (int i=0; i<self.text.length; i++) {
                NSString *str = [self.text substringWithRange:NSMakeRange(i, 1)];
                
                if (i==0) {
                    x = self.font.pointSize;
                }
                
                if ([str isEqualToString:@"\n"] || (y+self.font.pointSize > self.frame.size.height)) {
                    y = [str isEqualToString:@"\n"] ? 0 : self.font.pointSize;
                    if (x+_space+self.font.pointSize > self.frame.size.width) {
                        break;
                    }else {
                        x = x + _space + self.font.pointSize;
                    }
                }else {
                    y += self.font.pointSize;
                }
                if ([str isEqualToString:@"\n"]) continue;
                [str drawInRect:CGRectMake(x-self.font.pointSize, y-self.font.pointSize*1.05, self.font.pointSize, self.font.pointSize*1.1) withAttributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.textColor}];
            }
            break;
        }
    }
}

@end

@implementation NSString (ZHJVerticalLabel)

- (CGSize)verticalLabelWithinSize:(CGSize)size font:(UIFont *)font space:(CGFloat)space{
    if (size.width < font.pointSize || size.height < font.pointSize) {
        return CGSizeZero;
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat maxX = 0;
    CGFloat maxY = 0;
    
    for (int i=0; i<self.length; i++) {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        
        if (i==0) {
            x = font.pointSize;
        }
        
        if ([str isEqualToString:@"\n"] || (y+font.pointSize > size.height)) {
            y = [str isEqualToString:@"\n"] ? 0 : font.pointSize;
            if (x+space+font.pointSize > size.width) {
                break;
            }else {
                x = x + space + font.pointSize;
            }
        }else {
            y += font.pointSize;
        }
        maxX = MAX(x, maxX);
        maxY = MAX(y, maxY);
    }
    
    return CGSizeMake(MIN(maxX, size.width), MIN(maxY+font.pointSize*0.1, size.height));
}

@end

