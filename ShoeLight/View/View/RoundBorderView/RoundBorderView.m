//
//  RoundBorderView.m
//  ShoeLight
//
//  Created by even on 16/2/17.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "RoundBorderView.h"
#import "UIView+Frame.h"

@implementation RoundBorderView

- (void)awakeFromNib {
    self.layer.cornerRadius = self.width * 0.5;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

@end
