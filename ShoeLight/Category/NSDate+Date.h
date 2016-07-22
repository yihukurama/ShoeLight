//
//  NSDate+Date.h
//  Kido
//
//  Created by zhaoyd on 14-6-16.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Date)

//判断 日期是否是本周
- (BOOL)isThisWeek;

//日期是否是今天
- (BOOL)isToday;

//判断是不是今年
-(BOOL)isThisYear;

//把date（包含各种情况）转成时间字符串
- (NSString *)stringOfAnyDate;

//把date（今天）转成时间字符串
- (NSString *)stringOfHHmm;

//把date转成月日
- (NSString *)stringOfMMdd;

//把date转成年月日
- (NSString *)stringOfyyyyMMdd;

//把date（本周）转成时间字符串
- (NSString *)stringOfEEEEHHmm;

//把date（本年）转成时间字符串
- (NSString *)stringOfMMddHHmm;

//把date（去年及更早）转成时间字符串
- (NSString *)stringOfyyyyMMddHHmm;

// 根据一个date生成一个时间戳
- (NSString *)stringOfyyyyMMddHHmmss;

// 根据一个时间戳字符串生成一个date
+ (NSDate *)dateFromyyyyMMddHHmmss:(NSString *)string;

// 根据一个时间戳字符串生成一个date
+ (NSDate *)dateFromyyyyMMdd:(NSString *)string;

// 根据一个date生成一个秒的时间戳
- (NSString *)stringOfSecond;

// 根据一个date生成一个毫秒的时间戳
- (NSString *)stringOfMilliSecond;

// 根据毫秒生成date
+ (NSDate *)dateFromMilliSecond:(NSString *)timeStamp;

// 根据秒生成date
+ (NSDate *)dateFromSecond:(NSString *)timeStamp;
@end
