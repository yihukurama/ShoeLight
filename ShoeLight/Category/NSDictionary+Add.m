//
//  NSDictionary+Add.m
//  NewGS
//
//  Created by newgs_mac on 14/12/23.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import "NSDictionary+Add.h"

@implementation NSDictionary (Add)

- (NSString *)stringForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        // 字符
        return value;
        
    } else if ([value isKindOfClass:[NSNumber class]]) {
        // NSNumber
        return [NSString stringWithFormat:@"%@",value];
        
    } else {
        // NSNull nil NSArray
        return @"";
    }
}



- (NSNumber *)numForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        // NSNumber
        return value;
        
    } else if ([value isKindOfClass:[NSString class]]) {
        // 字符
        return @([value floatValue]);
        
    } else {
        // NSNull nil NSArray
        return @0;
    }
}


//- (CGFloat)floatForKey:(NSString *)key
//{
//    id value = [self valueForKey:key];
//    if ([value isKindOfClass:[NSNumber class]]) {
//        // NSNumber
//        return [value floatValue];
//        
//    } else if ([value isKindOfClass:[NSString class]]) {
//        // 字符
//        return [value floatValue];
//        
//    } else {
//        // NSNull nil NSArray
//        return 0;
//    }
//}


- (int)intForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        // NSNumber
        return [value intValue];
        
    } else if ([value isKindOfClass:[NSString class]]) {
        // 字符
        return [value intValue];
        
    } else {
        // NSNull nil NSArray
        return 0;
    }
}


- (BOOL)boolForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        // NSNumber
        return [value boolValue];
        
    } else if ([value isKindOfClass:[NSString class]]) {
        // 字符
        return [value boolValue];
        
    } else {
        // NSNull nil NSArray
        return 0;
    }
}


- (NSArray *)arrayForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        // NSArray
        return value;
        
    } else {
        
        return [NSArray array];
    }
}


- (NSDictionary *)dictForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSDictionary class]]) {

        return value;
        
    } else {

        return nil;
    }
}

@end
