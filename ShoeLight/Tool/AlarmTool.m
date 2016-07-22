//
//  AlarmTool.m
//  ShoeLight
//
//  Created by even on 16/3/4.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "AlarmTool.h"
#import "UserDefault.h"
#import "AudioTool.h"
#import "macro.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface AlarmTool () <AVAudioPlayerDelegate>

@property (strong, nonatomic) EZAudioPlayer *player;
@property (assign, nonatomic) NSInteger playingTimes;
@property (copy, nonatomic) NSString *playingAlarm;
@property (assign, nonatomic) bool hasShowHalfDistanceAlert; // 是否展示了半距离提示
@property (assign, nonatomic) bool hasShowFullDistanceAlert;
@property (assign, nonatomic) bool hasShowHalfTimeAlert; // 是否展示了半时间提示
@property (assign, nonatomic) bool hasShowFullTimeAlert;

@end


@implementation AlarmTool
single_implementation(AlarmTool)

#pragma mark - Public
- (void)playAlarm:(NSString *)alarmName times:(NSInteger)times {

    NSURL *url = [[NSBundle mainBundle]URLForResource:alarmName withExtension:@"mp3"];
    if (url == nil) {
        MyLog(@"找不到这个音乐文件：%@.mp3",alarmName);
        return;
    }
    
    if (self.player) {
        [self.player pause];
    }
    
    self.player = [AudioTool playMusicWithURL:url];
    self.player.volume = self.volume;
    self.player.delegate = self;
    self.playingTimes = times;
    self.playingAlarm = alarmName;
    
    [kNotificationCenter postNotificationName:kAlarmStartPlayNotification object:nil];
}

- (void)stopPlay {
    if (self.player) {
        [self.player pause];
    }
}


- (void)resetRunData {
    self.hasShowFullDistanceAlert = NO;
    self.hasShowFullTimeAlert = NO;
    self.hasShowHalfDistanceAlert = NO;
    self.hasShowHalfTimeAlert = NO;
}


#warning 有中文
- (void)showAlertIfNeededWithSecond:(NSInteger)second distance:(CGFloat)distance {
    
    bool needAlert = NO;
    NSString *alertMsg;
    
    // 时间
    if (self.timeAlarmIsOn) {
        // 判断是否到了半时间
        if (second >= self.timeAlarmMin * 60 * 0.5 && !self.hasShowHalfTimeAlert) {
            needAlert = YES;
            alertMsg = [LocalTool runReachHalfTime];
            self.hasShowHalfTimeAlert = YES;
        }
        
        
        // 判断是否到了全时间
        if (second >= self.timeAlarmMin * 60 && !self.hasShowFullTimeAlert) {
            needAlert = YES;
            alertMsg = [LocalTool runReachFullTime];
            self.hasShowFullTimeAlert = YES;
        }
    }
    
    
    // 距离
    if (self.distanceAlarmIsOn) {
        // 判断是否到了半距离
        if (distance >= self.distanceAlarmKm * 1000 * 0.5 && !self.hasShowHalfDistanceAlert) {
            needAlert = YES;
            alertMsg = [LocalTool runReachHalfDistance];
            self.hasShowHalfDistanceAlert = YES;
        }
        
        
        // 判断是否到了全距离
        if (distance >= self.distanceAlarmKm * 1000  && !self.hasShowFullDistanceAlert) {
            needAlert = YES;
            alertMsg = [LocalTool runReachFullDistance];
            self.hasShowFullDistanceAlert = YES;
        }
    }
    
    
    
    if (needAlert) {
        // 显示 Alert
        WEAKSELF
        [UIAlertView alertViewWithTitle:nil
                                message:alertMsg
                      cancelButtonTitle:[LocalTool cancel]
                      otherButtonTitles:nil
                              onDismiss:nil
                               onCancel:^{
                                   [weakSelf stopPlay];
                               }];
        if (kApplication.applicationState == UIApplicationStateActive) {
            
        } else {
            [self showLocalNotificationWithTitle:alertMsg];
        }
        
        // 播放声音
        if (self.isOn) {
            [self playAlarm:self.alarm times:self.time];
        }
    }
}

- (void)showLocalNotificationWithTitle:(NSString *)title {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = title;
    localNotification.alertAction = [LocalTool cancel];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    self.playingTimes --;
    if (self.playingTimes) {
        [self playAlarm:self.playingAlarm times:self.playingTimes];
    } else {
        [kNotificationCenter postNotificationName:kAlarmEndPlayNotification object:nil];
    }
    
}

#pragma mark - Private
- (void)setIsOn:(BOOL)isOn {
    SetUserDefaultBool(@"AlarmTool_isOn", isOn);
}
- (BOOL)isOn {
    return UserDefaultBool(@"AlarmTool_isOn");
}

- (void)setAlarm:(NSString *)alarm {
    SetUserDefaultObject(@"AlarmTool_alarm", alarm);
}
- (NSString *)alarm {
    return UserDefaultObject(@"AlarmTool_alarm");
}

- (void)setChineseAlarmName:(NSString *)chineseAlarmName {
    SetUserDefaultObject(@"AlarmTool_chineseAlarmName", chineseAlarmName);
}
- (NSString *)chineseAlarmName {
    return UserDefaultObject(@"AlarmTool_chineseAlarmName");
}

- (void)setEnglishAlarmName:(NSString *)englishAlarmName {
    SetUserDefaultObject(@"AlarmTool_englishAlarmName", englishAlarmName);
}
- (NSString *)englishAlarmName {
    return UserDefaultObject(@"AlarmTool_englishAlarmName");
}

- (void)setTime:(NSInteger)time {
    SetUserDefaultInteger(@"AlarmTool_time", time);
}
- (NSInteger)time {
    return UserDefaultInteger(@"AlarmTool_time");
}

- (void)setVolume:(CGFloat)volume {
    SetUserDefaultFloat(@"AlarmTool_volume", volume);
    
    if (self.player) {
        self.player.volume = volume;
    }
}
- (CGFloat)volume {
    return UserDefaultFloat(@"AlarmTool_volume");
}


//* 里程闹钟 */

- (void)setDistanceAlarmIsOn:(BOOL)distanceAlarmIsOn {
    SetUserDefaultBool(@"AlarmTool_distanceAlarmIsOn", distanceAlarmIsOn);
}
- (BOOL)distanceAlarmIsOn {
    return UserDefaultBool(@"AlarmTool_distanceAlarmIsOn");
}

- (void)setDistanceAlarmKm:(CGFloat)distanceAlarmKm {
    SetUserDefaultFloat(@"AlarmTool_distanceAlarmKm", distanceAlarmKm);
}
- (CGFloat)distanceAlarmKm {
    return UserDefaultFloat(@"AlarmTool_distanceAlarmKm");
}


///* 时间闹钟 */

- (void)setTimeAlarmIsOn:(BOOL)timeAlarmIsOn {
    SetUserDefaultBool(@"AlarmTool_timeAlarmIsOn", timeAlarmIsOn);
}
- (BOOL)timeAlarmIsOn {
    return UserDefaultBool(@"AlarmTool_timeAlarmIsOn");
}

- (void)setTimeAlarmMin:(NSInteger)timeAlarmMin {
    SetUserDefaultInteger(@"AlarmTool_timeAlarmMin", timeAlarmMin);
}
- (NSInteger)timeAlarmMin {
    return UserDefaultInteger(@"AlarmTool_timeAlarmMin");
}



- (void)setHasShowHalfDistanceAlert:(bool)hasShowHalfDistanceAlert {
    SetUserDefaultBool(@"AlarmTool_hasShowHalfDistanceAlert", hasShowHalfDistanceAlert);
}
- (BOOL)hasShowHalfDistanceAlert {
    return UserDefaultBool(@"AlarmTool_hasShowHalfDistanceAlert");
}

- (void)setHasShowFullDistanceAlert:(bool)hasShowFullDistanceAlert {
    SetUserDefaultBool(@"AlarmTool_hasShowFullDistanceAlert", hasShowFullDistanceAlert);
}
- (BOOL)hasShowFullDistanceAlert {
    return UserDefaultBool(@"AlarmTool_hasShowFullDistanceAlert");
}

- (void)setHasShowFullTimeAlert:(bool)hasShowFullTimeAlert {
    SetUserDefaultBool(@"AlarmTool_hasShowFullTimeAlert", hasShowFullTimeAlert);
}
- (BOOL)hasShowFullTimeAlert {
    return UserDefaultBool(@"AlarmTool_hasShowFullTimeAlert");
}

- (void)setHasShowHalfTimeAlert:(bool)hasShowHalfTimeAlert {
    SetUserDefaultBool(@"AlarmTool_hasShowHalfTimeAlert", hasShowHalfTimeAlert);
}
- (BOOL)hasShowHalfTimeAlert {
    return UserDefaultBool(@"AlarmTool_hasShowHalfTimeAlert");
}
@end
