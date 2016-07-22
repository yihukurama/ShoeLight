//
//  DayIdleRunCell.m
//  ShoeLight
//
//  Created by even on 16/3/3.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "DayIdleRunCell.h"
#import "macro.h"
#import "NSDate+Date.h"

@interface DayIdleRunCell ()

@property (weak, nonatomic) IBOutlet UILabel *stepLbl;
@property (weak, nonatomic) IBOutlet UILabel *calorieTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *calorieLbl;

@end

@implementation DayIdleRunCell

- (void)awakeFromNib {
    [self updateLanguage];
}

- (void)updateLanguage {
    self.calorieTextLbl.text = kMyProfileTool.isEnglish ? @"Calories" : @"卡路里kCal";
}

- (void)setDayIdleRun:(DayIdleRun *)dayIdleRun {
    _dayIdleRun = dayIdleRun;
    
    if (kMyProfileTool.isEnglish) {
        self.stepLbl.text = [NSString stringWithFormat:@"%@ step",@(dayIdleRun.totalStep)];
    } else {
        self.stepLbl.text = [NSString stringWithFormat:@"%@ 步",@(dayIdleRun.totalStep)];
    }
    
    self.dateLbl.text = [dayIdleRun.date stringOfyyyyMMdd];
    self.calorieLbl.text = [CommonTool caloriesStrWithDistance:dayIdleRun.totalDistance];

}@end
