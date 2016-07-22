//
//  CommonTool.h
//  ShoeLight
//
//  Created by even on 16/3/2.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^VoidBlock)();

@interface CommonTool : NSObject

// 将秒转换为mm:ss格式的字符串
+ (NSString *)mmssStrWithTimeInterval:(NSTimeInterval)interval;

// 将秒转换为hh:mm:ss格式的字符串
+ (NSString *)hhmmssStrWithTimeInterval:(NSTimeInterval)interval;

// 根据距离算出卡路里
+ (NSString *)caloriesStrWithDistance:(CGFloat)distance;

//浮点数处理并去掉多余的0
+ (NSString *)stringDisposeWithFloat:(float)floatValue;

+ (void)excuteBlockInLightMode:(VoidBlock)block;

+ (void)excuteBlockInMusicMode:(VoidBlock)block;

+ (void)excuteBlockInRunMode:(VoidBlock)block;

@end
