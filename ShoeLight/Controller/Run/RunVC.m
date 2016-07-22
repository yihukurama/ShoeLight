//
//  RunVC.m
//  ShoeLight
//
//  Created by even on 16/2/14.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "RunVC.h"
#import "UIViewController+TabBarVCDismiss.h"
#import "macro.h"
#import "NSTimer+Add.h"
#import "RunDataView.h"
#import "Run.h"

@interface RunVC ()

@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *overBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (weak, nonatomic) IBOutlet RunDataView *runDataView;
@property (weak, nonatomic) IBOutlet UILabel *currentStepTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentStepLbl;
@property (weak, nonatomic) IBOutlet UILabel *stepLbl;
@property (weak, nonatomic) IBOutlet UIButton *runHistoryBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *runDataViewBottomMarginCons;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) RunState runState;

@end

@implementation RunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDissmissBtnToLeftBarBtnItem];
    
    self.runState = RunStateIdle;
    [self updateBtns];
    [self updateLanguage];
    [self addRightBarBtnItem];
    
    if (kScreenHeight == 480) {
        self.runDataViewBottomMarginCons.constant = 0;
    } else if (kScreenHeight == 568) {
        self.runDataViewBottomMarginCons.constant = 20;
    } else {
        self.runDataViewBottomMarginCons.constant = 60;
    }
    
    self.view.backgroundColor = kGlbBgColor;
    [kNotificationCenter addObserver:self selector:@selector(completeRunIfNeeded) name:kBeginMusicModeNotification object:nil];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) addRightBarBtnItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:kMyProfileTool.isEnglish ? @"All Records" : @"累积记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClicked)];
}

- (void)tabBarVCWillDismiss {
    [self completeRunIfNeeded];
}

#pragma mark - Action
- (void)rightBarBtnClicked {
    [self performSegueWithIdentifier:@"TotalRunVC" sender:nil];
}

- (IBAction)start:(id)sender {
    
    if (![kBLE isConnectedRightShoe]) {
        [kHudTool showHudOneSecondWithText:[LocalTool rightShoeNeedToConnect]];
    } else {
        [CommonTool excuteBlockInRunMode:^{
            int gender = [kMyProfileTool.gender isEqualToString:@"male"] ? 1 : 0;
            Byte bytes[] = {0xA6,kMyProfileTool.height,gender};
            [kBLE writeBytesForPeripheral:bytes length:3];
            [kNotificationCenter postNotificationName:kBeginRunModeNotification object:nil];
        }];
    }
}

- (IBAction)over:(id)sender {
    Byte bytes[] = {0xA7};
    [kBLE writeBytesForPeripheral:bytes length:1];
}

- (void)sendRunDataBackCmd {
    Byte bytes[] = {0xAA,0xA2,0xAA,0xA3};
    [kBLE writeBytesForPeripheral:bytes length:4];
}

- (IBAction)pause:(id)sender {
    kMyProfileTool.storedSeconds = [[NSDate date]timeIntervalSinceDate:kMyProfileTool.startDate] + kMyProfileTool.storedSeconds;
    self.runState = RunStatePause;
    [self.timer pause];
    [self updateBtns];
}

- (IBAction)resume:(id)sender {
    kMyProfileTool.startDate = [NSDate date];
    [self.timer resume];
    self.runState = RunStateRun;
    [self updateBtns];
}

- (void)completeRunIfNeeded {
    if (self.runState == RunStateRun) {
        // 结束
        self.currentStepLbl.text = @"0";
        self.runState = RunStateIdle;
        [self.runDataView clearData];
        [self.timer pause];
        [self updateBtns];
        
        // 更新累积记录时间
        kMyProfileTool.totalTime += [[NSDate date]timeIntervalSinceDate:kMyProfileTool.startDate];
        kMyProfileTool.currentMode = ModeIdle;
        
        if (kMyProfileTool.currentStep) {
            [Run runWithStartDate:kMyProfileTool.startDate
                         stopDate:[NSDate date]
                             step:kMyProfileTool.currentStep
                         distance:kMyProfileTool.currentDistance
                       isIdleMode:NO];
        }
    }
}

#pragma mark - Getter
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSubviews) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - Private

- (void)updateSubviews {
    
    NSDate *now = [NSDate date];
    if ([now timeIntervalSinceDate:kMyProfileTool.lastStepDataDate] > 5) {
        kMyProfileTool.currentSpeed = 0;
        kMyProfileTool.lastStepDataDate = now;
    }
    
    self.currentStepLbl.text = [NSString stringWithFormat:@"%@",@(kMyProfileTool.currentStep)];
    [self updateTime];
    self.runDataView.distenceLbl.text = [NSString stringWithFormat:@"%.2f",kMyProfileTool.currentDistance * 0.001];
    self.runDataView.calorieLbl.text = [CommonTool caloriesStrWithDistance:kMyProfileTool.currentDistance];
    self.runDataView.speedLbl.text = [NSString stringWithFormat:@"%.2f",kMyProfileTool.currentSpeed];
}

// 更新时间
- (void)updateTime {
    if (self.runState == RunStateIdle) {
        self.runDataView.timeLbl.text = @"00:00:00";
    } else {
        NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:kMyProfileTool.startDate]  + kMyProfileTool.storedSeconds;
        self.runDataView.timeLbl.text = [CommonTool hhmmssStrWithTimeInterval:interval];
        [kAlarmTool showAlertIfNeededWithSecond:interval distance:kMyProfileTool.currentDistance];
    }
}

// 根据状态，刷新按钮的显示
- (void)updateBtns {
    switch (self.runState) {
        case RunStateIdle: // 空闲
            self.startBtn.hidden = NO;
            self.distanceBtn.hidden = NO;
            self.timeBtn.hidden = NO;
            self.pauseBtn.hidden = YES;
            self.resumeBtn.hidden = YES;
            self.overBtn.hidden = YES;
            break;
            
        case RunStateRun: // 跑步中
            self.startBtn.hidden = YES;
            self.distanceBtn.hidden = YES;
            self.timeBtn.hidden = YES;
            self.pauseBtn.hidden = NO;
            self.resumeBtn.hidden = YES;
            self.overBtn.hidden = NO;
            break;
            
        case RunStatePause: // 暂停
            self.startBtn.hidden = YES;
            self.distanceBtn.hidden = YES;
            self.timeBtn.hidden = YES;
            self.resumeBtn.hidden = NO;
            self.pauseBtn.hidden = YES;
            self.overBtn.hidden = NO;
            break;
        default:
            break;
    }
}


- (void)updateLanguage {
    if (kMyProfileTool.isEnglish) {
        [self.distanceBtn setTitle:@"Distance" forState:UIControlStateNormal];
        [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
        [self.timeBtn setTitle:@"Time" forState:UIControlStateNormal];
        [self.pauseBtn setTitle:@"Pause" forState:UIControlStateNormal];
        [self.overBtn setTitle:@"Complete" forState:UIControlStateNormal];
        
        self.currentStepTextLbl.text = @"Current Steps";
        self.stepLbl.text = @"Step";
        [self.runHistoryBtn setTitle:@"Exercise log" forState:UIControlStateNormal];
        self.navigationItem.title = @"Sports Mode";
        
    } else {
        [self.distanceBtn setTitle:@"运动距离" forState:UIControlStateNormal];
        [self.startBtn setTitle:@"开始" forState:UIControlStateNormal];
        [self.timeBtn setTitle:@"运动时间" forState:UIControlStateNormal];
        [self.pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [self.overBtn setTitle:@"完成" forState:UIControlStateNormal];
        
        self.currentStepTextLbl.text = @"当前步数";
        self.stepLbl.text = @"步";
        [self.runHistoryBtn setTitle:@"运动记录" forState:UIControlStateNormal];
        self.navigationItem.title = @"运动模式";
    }
}


#pragma mark - BLE代理方法
- (void)didUpdateValueForRightShoe
{
    NSArray *array = [[BLE sharedInstance] deviceCallBack];
    if (array.count != 0) {
        
        NSData *data = [array objectAtIndex:0];
        Byte *bytes = (Byte *)[data bytes];
        
        if (bytes[0] == 0xA2) {
            // 步数
            int a = bytes[3];
            int b = bytes[2];
            int c = bytes[1];
            NSInteger step = (a << 16) + (b << 8) + c;
            MyLog(@"收到步数%@",@(step));
            
            int e = bytes[7];
            int f = bytes[6];
            int g = bytes[5];
            CGFloat distance = ((e << 16) + (f << 8) + g) * 0.01;
            MyLog(@"收到距离%@",@(distance));
            
            int h = bytes[9];
            int i = bytes[8];
            CGFloat speed = ((h << 8) + i) * 0.01;
            MyLog(@"收到速度%@",@(speed));
            
            if (self.runState == RunStateRun) {
                kMyProfileTool.currentStep += step;
                kMyProfileTool.currentDistance += distance;
                kMyProfileTool.currentSpeed = speed;
                kMyProfileTool.lastStepDataDate = [NSDate date];
                
                // 更新累积记录
                kMyProfileTool.totalDistance += distance;
                kMyProfileTool.totalStep += step;
                
            } else {
                // 闲时记录
                [Run runWithStartDate:[NSDate date]
                             stopDate:[NSDate date]
                                 step:step
                             distance:distance
                           isIdleMode:YES];
            }
            
            [self sendRunDataBackCmd];
            
        } else if (bytes[0] == 0xAA) {
            // 回执
            if (bytes[1] == 0xA6) {
                // 启动
                [self.runDataView clearData];
                self.runState = RunStateRun;
                
                kMyProfileTool.startDate = [NSDate date];
                kMyProfileTool.storedSeconds = 0;
                kMyProfileTool.currentDistance = 0;
                kMyProfileTool.currentStep = 0;
                kMyProfileTool.currentSpeed = 0;
                kMyProfileTool.lastStepDataDate = [NSDate date];
                kMyProfileTool.currentMode = ModeRun;
                [self.timer resume];
                [self updateBtns];
                [kAlarmTool resetRunData];
                
            } else if (bytes[1] == 0xA7 ) {
                // 结束
                self.currentStepLbl.text = @"0";
                self.runState = RunStateIdle;
                [self.runDataView clearData];
                [self.timer pause];
                [self updateBtns];
                
                // 更新累积记录时间
                kMyProfileTool.totalTime += [[NSDate date]timeIntervalSinceDate:kMyProfileTool.startDate];
                kMyProfileTool.currentMode = ModeIdle;
                
                if (kMyProfileTool.currentStep) {
                    [Run runWithStartDate:kMyProfileTool.startDate
                                 stopDate:[NSDate date]
                                     step:kMyProfileTool.currentStep
                                 distance:kMyProfileTool.currentDistance
                               isIdleMode:NO];
                }
                
            } else if (bytes[1] == 0xA8) {
                // 设备信息
                int version = bytes[2];
                int highVersion = version & 0x10;
                int lowVersion = version & 0x01;
                kMyProfileTool.deviceVersion = [NSString stringWithFormat:@"%@.%@",@(highVersion),@(lowVersion)];
            }
        }
    }
}

@end
