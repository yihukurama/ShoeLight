//
//  AlarmSettingVC.m
//  ShoeLight
//
//  Created by even on 16/2/13.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "AlarmSettingVC.h"
#import "macro.h"
#import "AlarmTool.h"
#import "AlarmTouchView.h"
#import "UIResponder+Router.h"

@interface AlarmSettingVC ()
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UILabel *alarmLbl;

@property (weak, nonatomic) IBOutlet UILabel *alarmTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *chooseAlarmTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *volumeTextLbl;

@property (weak, nonatomic) IBOutlet UILabel *smallTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *bigTextLbl;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet AlarmTouchView *touchView;

@property (strong, nonatomic) AlarmTool *alarmTool;
@end

@implementation AlarmSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kGlbBgColor;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self updateLanguage];
    
    self.alarmTool = [AlarmTool sharedAlarmTool];
    self.switcher.on = self.alarmTool.isOn;
    self.volumeSlider.value = self.alarmTool.volume;
    self.timeSlider.value = self.alarmTool.time;
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"line_clock_adjust"] forState:UIControlStateNormal];
    
    WEAKSELF
    self.touchView.chooseIndexBlock = ^ (int index) {
        weakSelf.timeSlider.value = index + 1;
        [weakSelf timeSliderValueChanged:weakSelf.timeSlider];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.alarmLbl.text = kMyProfileTool.isEnglish ? kAlarmTool.englishAlarmName : kAlarmTool.chineseAlarmName;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (IBAction)timeSliderValueChanged:(UISlider *)sender {
    sender.value = floorf(sender.value + 0.5);
    self.alarmTool.time = sender.value;
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo {
    [self timeSliderValueChanged:self.timeSlider];
}


- (IBAction)switcherValueChanged:(UISwitch *)sender {
    self.alarmTool.isOn = sender.on;
}

- (IBAction)volumeSliderValueChanged:(UISlider *)sender {
    self.alarmTool.volume = sender.value;
}

- (void)updateLanguage {
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Alarm" : @"闹铃方式";
    
    self.alarmTextLbl.text = kMyProfileTool.isEnglish ? @"Alarm" : @"闹铃";
    self.chooseAlarmTextLbl.text = kMyProfileTool.isEnglish ? @"Ringtone" : @"铃声选择";
    self.alarmTimeTextLbl.text = kMyProfileTool.isEnglish ? @"Alarm Times" : @"闹铃次数";
    self.volumeTextLbl.text = kMyProfileTool.isEnglish ? @"Volume" : @"音量";
    
    self.smallTextLbl.text = kMyProfileTool.isEnglish ? @"Small" : @"小";
    self.bigTextLbl.text = kMyProfileTool.isEnglish ? @"Loud" : @"大";

}
@end
