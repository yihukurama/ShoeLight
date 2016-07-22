//
//  Run.m
//  ShoeLight
//
//  Created by even on 16/3/2.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "Run.h"
#import "macro.h"

@implementation Run

+ (instancetype)runWithStartDate:(NSDate *)start
                        stopDate:(NSDate *)stop
                            step:(NSInteger)step
                        distance:(CGFloat)distance
                      isIdleMode:(BOOL)isIdleMode {
    Run * run = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:kDBManager.context];
    run.startDate = [start timeIntervalSince1970];
    run.stopDate = [stop timeIntervalSince1970];
    run.step = (int32_t)step;
    run.distance = distance;
    run.isIdleMode = isIdleMode;
    return run;
}

@end
