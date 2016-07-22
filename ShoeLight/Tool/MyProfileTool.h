//
//  MyProfileTool.h
//  NewGS
//
//  Created by zhaoyd on 14-11-13.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    ModeIdle,
    ModeRun,   // 运动模式
    ModeLight, // 炫彩模式
    ModeMusic, // 音乐模式
} Mode;


@interface MyProfileTool : NSObject
single_interface(MyProfileTool)

/* 当前模式 */
@property (assign, nonatomic) Mode  currentMode;

/* 个人信息相关 */
@property (copy, nonatomic) NSString *gender; // 男 male 女female
@property (assign, nonatomic) NSInteger age;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger weight;

/* 设备信息 */
@property (copy, nonatomic) NSString *deviceVersion;

/* 运动模式信息 */
@property (assign, nonatomic) NSInteger currentStep;// 当前步数
@property (assign, nonatomic) CGFloat currentDistance;// 当前距离
@property (assign, nonatomic) CGFloat currentSpeed;// 当前速度
@property (assign, nonatomic) NSDate *lastStepDataDate; // 上一次接收到计步数据的时间
@property (assign, nonatomic) NSInteger storedSeconds; // 已经跑步的秒数，如果用户点了暂停，此参数会有值，同时startDate会刷新
@property (assign, nonatomic) NSDate *startDate; // 开始跑步的时间，以秒表示

/* 累积记录 */
@property (assign, nonatomic) NSInteger totalStep;
@property (assign, nonatomic) NSInteger totalDistance;
@property (assign, nonatomic) NSInteger totalTime;

@property (assign, nonatomic) BOOL isEnglish;
@property (assign, nonatomic) BOOL hasInBefore;

// 根据下载的字典配置自己的信息
- (void)configureWithDict:(NSDictionary *)dict;
- (void)logout;

@end
