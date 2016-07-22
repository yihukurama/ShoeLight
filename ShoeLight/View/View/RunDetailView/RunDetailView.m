//
//  RunDetailView.m
//  ShoeLight
//
//  Created by even on 16/2/14.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "RunDetailView.h"
#import "RunDataView.h"
#import "macro.h"
#import "CommonTool.h"
#import "NSDate+Date.h"

@interface RunDetailView ()

@property (weak, nonatomic) IBOutlet UILabel *thisTimeStepTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *stepLbl;

@end

@implementation RunDetailView

- (void)awakeFromNib {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = kGlbBgColor;
}

+ (instancetype)runDetailView {
    return [[[NSBundle mainBundle]loadNibNamed:@"RunDetailView" owner:nil options:nil]lastObject];
}


- (void)updateLanguage {
    if (self.isTotal) {
        self.thisTimeStepTextLbl.text = kMyProfileTool.isEnglish ? @"All Records" : @"累积步数";
    } else {
        self.thisTimeStepTextLbl.text = kMyProfileTool.isEnglish ? @"Steps this time" : @"本次步数";
    }
    
    [self.runDataView updateLanguage];
}

- (void)setIsTotal:(BOOL)isTotal {
    _isTotal = isTotal;
    self.timeLbl.hidden = isTotal;
    self.runDataView.isTotal = isTotal;
    [self updateLanguage];
}

- (void)setRun:(Run *)run {
    _run = run;
    self.runDataView.run = run;
    self.step = run.step;
    self.timeLbl.text = [[NSDate dateWithTimeIntervalSince1970:run.startDate] stringOfMMddHHmm];
}

- (void)setStep:(NSInteger)step {
    _step = step;
    
    NSString *str = kMyProfileTool.isEnglish ? [NSString stringWithFormat:@"%@ Step",@(step)] : [NSString stringWithFormat:@"%@ 步",@(step)];
    NSRange spaceRange = [str rangeOfString:@" "];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(0, spaceRange.location)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(spaceRange.location + 1, str.length - spaceRange.location - 1)];
    self.stepLbl.attributedText = attrStr;
}

@end
