//
//  NSDate+Date.m
//  Kido
//
//  Created by zhaoyd on 14-6-16.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate (Date)

/**
 **判断 日期是否是本周
 **/

- (BOOL)isThisWeek
{
    NSDate *start;
    NSTimeInterval extends;
    
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    [cal setFirstWeekday:2];//一周的第一天设置为周一
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval: &extends forDate:today];
    
    if(!success) {
        return NO;
    }
    
    NSTimeInterval dateInSecs = [self timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs >= dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    } else {
        return NO;
    }
}


// 日期是否是今天
- (BOOL)isToday

{
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    
    // 1. 获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components :unit fromDate :[ NSDate date ]];
    
    // 2. 获得 self 的年月日
    NSDateComponents *selfCmps = [calendar components :unit fromDate : self ];
    //直接分别用当前对象和现在的时间进行比较，比较的属性就是年月日
    return (selfCmps. year == nowCmps. year ) && (selfCmps. month == nowCmps. month ) &&(selfCmps. day == nowCmps. day );
}

//判断是不是今年
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    //获取当前的年月日
    NSDateComponents  *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    //获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate: self];
    return nowCmps.year == selfCmps.year ;
}


//把date（包含各种情况）转成时间字符串
- (NSString *)stringOfAnyDate
{
    NSString *str;
    
    if ([self isToday]) {
        str = [self stringOfHHmm];
    } else if ([self isThisWeek]) {
        str = [self stringOfEEEEHHmm];
    } else if ([self isThisYear]) {
        str = [self stringOfMMddHHmm];
    } else {
        str = [self stringOfyyyyMMddHHmm];
    }
    return str;
}


//把date（今天）转成时间字符串
- (NSString *)stringOfHHmm
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"HH:mm";
	NSString *tempstr = [dateFormatter stringFromDate:self];
	return tempstr;
}

//把date（本周）转成时间字符串
- (NSString *)stringOfEEEEHHmm
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
     //setLocale 方法将其转为中文的日期表达
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"EEEE HH:mm";
	NSString *tempstr = [dateFormatter stringFromDate:self];
	return tempstr;
}

//把date（本年）转成时间字符串
- (NSString *)stringOfMMddHHmm
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"MM-dd HH:mm";
	NSString *tempstr = [dateFormatter stringFromDate:self];
	return tempstr;
}


//把date转成年月日
- (NSString *)stringOfyyyyMMdd
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSString *tempstr = [dateFormatter stringFromDate:self];
	return tempstr;
}


//把date转成月日
- (NSString *)stringOfMMdd
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"MM-dd";
	NSString *tempstr = [dateFormatter stringFromDate:self];
	return tempstr;
}


//把date（去年及更早）转成时间字符串
- (NSString *)stringOfyyyyMMddHHmm
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
	NSString *tempstr = [dateFormatter stringFromDate:self];
	return tempstr;
}



// 根据一个date生成一个时间戳
- (NSString *)stringOfyyyyMMddHHmmss
{
    //2014-06-03 10:18:02
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * timeStamp = [formatter stringFromDate:self];
    return timeStamp;
}


// 根据一个时间戳字符串生成一个date
+ (NSDate *)dateFromyyyyMMddHHmmss:(NSString *)string
{
    if (!string.length) {
        string = @"1970-01-01 00:00:00";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:string];
    return date;
}



// 根据一个时间戳字符串生成一个date
+ (NSDate *)dateFromyyyyMMdd:(NSString *)string
{
    if (!string.length) {
        string = @"1970-01-01";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:string];
    return date;
}



// 根据一个date生成一个秒的时间戳
- (NSString *)stringOfSecond
{
    long long second = [self timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lli",second];
}

// 根据一个date生成一个毫秒的时间戳
- (NSString *)stringOfMilliSecond
{
    long long second = [self timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lli",second * 1000];
}


// 根据毫秒生成date
+ (NSDate *)dateFromMilliSecond:(NSString *)timeStamp
{
    if (!timeStamp.length) {
        timeStamp = @"0";
    }
    return  [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue] * 0.001];
}



// 根据秒生成date
+ (NSDate *)dateFromSecond:(NSString *)timeStamp
{
    if (!timeStamp.length) {
        timeStamp = @"0";
    }
    return  [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
}

@end
