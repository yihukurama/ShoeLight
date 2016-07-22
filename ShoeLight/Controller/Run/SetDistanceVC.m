//
//  SetDistanceVC.m
//  ShoeLight
//
//  Created by even on 16/2/19.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "SetDistanceVC.h"
#import "macro.h"


@interface SetDistanceVC ()

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *distanceTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *alarmTextLbl;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UITextField *distanceFld;

@end
@implementation SetDistanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kGlbBgColor;
    
    self.saveBtn.layer.cornerRadius = 5;
    self.saveBtn.layer.borderColor = kGetColorFromHex(0xfc4851, 1).CGColor;
    self.saveBtn.layer.borderWidth = 1;
    self.saveBtn.layer.masksToBounds = YES;
    [self.saveBtn setTitleColor:kGetColorFromHex(0xfc4851, 1) forState:UIControlStateNormal];
    
    [self updateLanguage];
    
    self.switcher.on = kAlarmTool.distanceAlarmIsOn;
    self.distanceFld.text = [CommonTool stringDisposeWithFloat:kAlarmTool.distanceAlarmKm];
}

- (void)updateLanguage {
    self.distanceTextLbl.text = kMyProfileTool.isEnglish ? @"Mileage(km)" : @"运动里程(km)";
    self.alarmTextLbl.text = kMyProfileTool.isEnglish ? @"Alarm" : @"闹钟";
    
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Mileage Settings" : @"里程设置";
    
    [self.completeBtn setTitle:kMyProfileTool.isEnglish ? @"Complete" : @"完成" forState:UIControlStateNormal];
}

- (IBAction)done:(id)sender {
    if (self.switcher.on && [self.distanceFld.text floatValue] == 0) {
        [kHudTool showHudOneSecondWithText:@"运动里程不能为0"];
        return;
    }
    
    kAlarmTool.distanceAlarmIsOn = self.switcher.on;
    kAlarmTool.distanceAlarmKm = [self.distanceFld.text floatValue];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fldEditingDidBegin:(UITextField *)sender {
    if ([sender.text integerValue] == 0) {
        sender.text = @"";
    }
}



#define kMaxDistance 10000
- (IBAction)fldEditingDidChanged:(UITextField *)sender {
    NSInteger input = [sender.text integerValue];
    if (input <= 0) {
        sender.text = @"";
    }
    
    else if (input > kMaxDistance) {
        input = kMaxDistance;
        sender.text = [NSString stringWithFormat:@"%@",@(input)];
    }
    else {
        sender.text = [NSString stringWithFormat:@"%@",@(input)];
    }
}
@end
