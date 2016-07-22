//
//  AlarmTool.h
//  ShoeLight
//
//  Created by even on 16/3/4.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"

#define kAlarmStartPlayNotification @"kAlarmStartPlayNotification"
#define kAlarmEndPlayNotification @"kAlarmEndPlayNotification"

@interface AlarmTool : NSObject
single_interface(AlarmTool)

/* 声音总闹钟 */
@property (assign, nonatomic) BOOL isOn;
@property (copy, nonatomic) NSString *alarm; // 实际名字
@property (copy, nonatomic) NSString *chineseAlarmName;
@property (copy, nonatomic) NSString *englishAlarmName;
@property (assign, nonatomic) NSInteger time;// 次数
@property (assign, nonatomic) CGFloat volume;

/* 里程闹钟 */
@property (assign, nonatomic) BOOL distanceAlarmIsOn;
@property (assign, nonatomic) CGFloat distanceAlarmKm;

/* 时间闹钟 */
@property (assign, nonatomic) BOOL timeAlarmIsOn;
@property (assign, nonatomic) NSInteger timeAlarmMin;


/**
 *  播放闹钟
 *
 *  @param alarmName 闹铃名字
 *  @param times     次数
 */
- (void)playAlarm:(NSString *)alarmName times:(NSInteger)times;
- (void)stopPlay;


/**
 *  在跑步跑了距离或者时间的，一半或者全部，如果用户开启了提醒，就闹铃或者弹窗提醒用户
 *
 *  @param second   当前跑步的时间(min)
 *  @param distance 当前跑步的距离(s)
 */
- (void)showAlertIfNeededWithSecond:(NSInteger)second distance:(CGFloat)distance;
- (void)resetRunData;

@end
