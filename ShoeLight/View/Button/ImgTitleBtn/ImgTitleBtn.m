//
//  ImgTitleBtn.m
//  ShoeLight
//
//  Created by even on 16/2/19.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "ImgTitleBtn.h"

@implementation ImgTitleBtn

- (void)awakeFromNib {
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.imageEdgeInsets = UIEdgeInsetsZero;
}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    CGFloat imgW = self.imageView.image.size.width;
    CGFloat btnH = self.frame.size.height;
    CGSize lblSize = [self labelSize];
    
    CGFloat lblH = lblSize.height;
    CGFloat lblW = lblSize.width;
    
    CGFloat lblOffsetX = (imgW + lblW / 2) - (imgW + lblW) / 2;
    CGFloat lblOffsetY = (btnH - lblH) / 2;
    titleEdgeInsets = UIEdgeInsetsMake(0, -lblOffsetX * 2, -lblOffsetY * 2, 0);
    [super setTitleEdgeInsets:titleEdgeInsets];
}

- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    
//    CGFloat imgW = self.imageView.image.size.width;
    CGFloat imgH = self.imageView.image.size.height;
    CGFloat btnH = self.frame.size.height;
//    CGFloat btnW = self.frame.size.width;
    CGFloat lblW = [self labelSize].width;
    CGFloat imgOffsetX = lblW;//(imgW + lblW) / 2 - imgW / 2;
    CGFloat imgOffsetY = (btnH - imgH) / 2;
    
    imageEdgeInsets= UIEdgeInsetsMake(-imgOffsetY * 2, imgOffsetX, 0, 0);
    [super setImageEdgeInsets:imageEdgeInsets];
}

- (CGSize)labelSize {
    NSDictionary *attr = @{NSFontAttributeName:self.titleLabel.font};
    return [self.titleLabel.text boundingRectWithSize:CGSizeMake(10000, 10000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}
@end
