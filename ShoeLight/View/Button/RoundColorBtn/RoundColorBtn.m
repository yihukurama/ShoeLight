//
//  RoundColorBtn.m
//  NewGS
//
//  Created by even on 15/9/11.
//  Copyright (c) 2015年 cnmobi. All rights reserved.
//

#import "RoundColorBtn.h"

@implementation RoundColorBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    // 默认为橙色
    self.backgroundColor = [UIColor orangeColor];
}


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [self setBackgroundImage:[self imageWithColor:backgroundColor size:self.frame.size] forState:UIControlStateNormal];
}


- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
@end
