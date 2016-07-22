//
//  SetTimeVC.m
//  ShoeLight
//
//  Created by even on 16/2/19.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "SetTimeVC.h"
#import "macro.h"

@interface SetTimeVC ()
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *alarmTextLbl;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UITextField *timeFld;

@end
@implementation SetTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kGlbBgColor;
    
    self.saveBtn.layer.cornerRadius = 5;
    self.saveBtn.layer.borderColor = kGetColorFromHex(0xfc4851, 1).CGColor;
    self.saveBtn.layer.borderWidth = 1;
    self.saveBtn.layer.masksToBounds = YES;
    [self.saveBtn setTitleColor:kGetColorFromHex(0xfc4851, 1) forState:UIControlStateNormal];
    
    [self updateLanguage];
    
    self.switcher.on = kAlarmTool.timeAlarmIsOn;
    self.timeFld.text = [NSString stringWithFormat:@"%@",@(kAlarmTool.timeAlarmMin)];
}

- (void)updateLanguage {
    self.timeTextLbl.text = kMyProfileTool.isEnglish ? @"Duration(min)" : @"运动时长(min)";
    self.alarmTextLbl.text = kMyProfileTool.isEnglish ? @"Alarm" : @"闹钟";
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Appointment Time" : @"预约时间";
    [self.completeBtn setTitle:kMyProfileTool.isEnglish ? @"Complete" : @"完成" forState:UIControlStateNormal];
}


- (IBAction)done:(id)sender {
    if (self.switcher.on && [self.timeFld.text integerValue] == 0) {
        [kHudTool showHudOneSecondWithText:@"运动时长不能为0"];
        return;
    }
    
    kAlarmTool.timeAlarmIsOn = self.switcher.on;
    kAlarmTool.timeAlarmMin = [self.timeFld.text integerValue];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)fldEditingDidBegin:(UITextField *)sender {
    if ([sender.text integerValue] == 0) {
        sender.text = @"";
    }
}


#define kMaxTime 10000
- (IBAction)fldEditingDidChanged:(UITextField *)sender {
    NSInteger input = [sender.text integerValue];
    if (input <= 0) {
        sender.text = @"";
    }
    
    else if (input > kMaxTime) {
        input = kMaxTime;
        sender.text = [NSString stringWithFormat:@"%@",@(input)];
    }
    else {
        sender.text = [NSString stringWithFormat:@"%@",@(input)];
    }
}
@end
