//
//  LightTypeView.m
//  ShoeLight
//
//  Created by even on 16/2/24.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "LightTypeView.h"
#import "macro.h"
#import "UIView+Frame.h"

#define kMargin  35   // 左右圆点距离左右边的距离



@interface LightTypeView ()

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSMutableArray *dotImgViews;
@property (strong, nonatomic) NSMutableArray *lbls;
@property (strong, nonatomic) UIImageView *thumbImgView;

@end

@implementation LightTypeView

- (void)awakeFromNib {
    [self addSubviews];
}

- (void)addSubviews {
    
    // 添加lineView
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = kGetColorFromRGB(63, 63, 63, 1);
    self.lineView.layer.borderColor = kGetColorFromRGB(83, 83, 83, 1).CGColor;
    self.lineView.layer.borderWidth = 1;
    self.lineView.layer.masksToBounds = YES;
    [self addSubview:self.lineView];
    
    
    // dotImgViews labels
    self.dotImgViews = [NSMutableArray array];
    self.lbls = [NSMutableArray array];
    
    for (int i = 0; i < 4; i ++) {
        UIImageView *dot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_shanguangdian"]];
        [self addSubview:dot];
        [self.dotImgViews addObject:dot];
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.font = [UIFont systemFontOfSize:12];
        switch (i) {
            case 0:
                lbl.text = kMyProfileTool.isEnglish ? @"Always on" : @"常亮";
                break;
            case 1:
                lbl.text = kMyProfileTool.isEnglish ? @"Slow flash" : @"慢闪";
                break;
            case 2:
                lbl.text = kMyProfileTool.isEnglish ? @"Quick flash" : @"快闪";
                break;
            case 3:
                lbl.text = kMyProfileTool.isEnglish ? @"RGB flash" : @"七彩闪";
                break;
            default:
                break;
        }
        [self addSubview:lbl];
        [lbl sizeToFit];
        [self.lbls addObject:lbl];
    }
    
    // thumbImgView
    UIImageView *thumb = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_sun_all"]];
    self.thumbImgView = thumb;
    [self addSubview:self.thumbImgView];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat lineX = kMargin;
    CGFloat lineY = 41;
    CGFloat lineW = self.width - kMargin * 2;
    CGFloat lineH = 3;
    self.lineView.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
    

    
    for (int i = 0; i < 4; i ++) {
        CGFloat dotCenterX = kMargin + i * lineW / 3.0;
        UIImageView *imgView = self.dotImgViews[i];
        imgView.center = CGPointMake(dotCenterX, self.lineView.center.y);
        
        
        UILabel *lbl = self.lbls[i];
        lbl.center = CGPointMake(dotCenterX, self.lineView.center.y + 35);
        
        if (i == self.selectedIndex) {
            lbl.textColor = kWhiteColor;
            self.thumbImgView.center = imgView.center;
        } else {
            lbl.textColor = kGetColorFromHex(0x999999, 1);
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [self setNeedsLayout];
    
    if (self.valueChangedBlock) {
        self.valueChangedBlock(selectedIndex);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGFloat touchX = [touch locationInView:self.lineView].x;
//    CGFloat touchY = [touch locationInView:self.lineView].y;
    
    NSInteger index = (touchX + self.lineView.width / 6) * 3 / self.lineView.width;
    
    if (self.shouldValueChangeBlock(index)) {
        self.selectedIndex = index;
    }
    



}

@end
