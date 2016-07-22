//
//  NSTimer+Add.m
//  SmartSocket
//
//  Created by zhaoyd on 14-8-19.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import "NSTimer+Add.h"

@implementation NSTimer (Add)


-(void)pause
{
    if (![self isValid]) {
        return ;
    }
    
    [self setFireDate:[NSDate distantFuture]];
    
    
}


-(void)resume
{
    
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
    
}

@end
