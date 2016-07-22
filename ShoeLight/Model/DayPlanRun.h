//
//  DayPlanRun.h
//  ShoeLight
//
//  Created by even on 16/3/2.
//  Copyright © 2016年 Aiden. All rights reserved.
//  一天的运动模式跑步数据

#import <Foundation/Foundation.h>
#import "Run.h"

@interface DayPlanRun : NSObject

@property (assign, nonatomic) NSInteger totalStep;
@property (strong, nonatomic) NSMutableArray *runs;
@property (strong, nonatomic) NSDate *date;

@end
