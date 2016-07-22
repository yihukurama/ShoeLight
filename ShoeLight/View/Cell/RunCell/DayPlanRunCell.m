//
//  RunCell.m
//  ShoeLight
//
//  Created by even on 16/2/23.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "DayPlanRunCell.h"
#import "macro.h"
#import "NSDate+Date.h"

@interface DayPlanRunCell ()
@property (weak, nonatomic) IBOutlet UILabel *stepLbl;
@property (weak, nonatomic) IBOutlet UILabel *runTimeTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *runTimeLbl;

@end

@implementation DayPlanRunCell

- (void)awakeFromNib {
    [self updateLanguage];
}

- (void)updateLanguage {
    self.runTimeTextLbl.text = kMyProfileTool.isEnglish ? @"Exercise times" : @"运动次数";
    
}

- (void)setDayPlanRun:(DayPlanRun *)dayPlanRun {
    _dayPlanRun = dayPlanRun;
    
    if (kMyProfileTool.isEnglish) {
        self.stepLbl.text = [NSString stringWithFormat:@"%@ Step",@(dayPlanRun.totalStep)];
    } else {
        self.stepLbl.text = [NSString stringWithFormat:@"%@ 步",@(dayPlanRun.totalStep)];
    }
    
    self.dateLbl.text = [dayPlanRun.date stringOfyyyyMMdd];
    self.runTimeLbl.text = [NSString stringWithFormat:@"%@",@(dayPlanRun.runs.count)];
}

@end
