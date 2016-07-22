//
//  DayIdleRun.h
//  ShoeLight
//
//  Created by even on 16/3/2.
//  Copyright © 2016年 Aiden. All rights reserved.
// 一天的闲时跑步数据

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DayIdleRun : NSObject

@property (assign, nonatomic) NSInteger totalStep;
@property (assign, nonatomic) CGFloat totalDistance;
@property (strong, nonatomic) NSDate *date;


@end
