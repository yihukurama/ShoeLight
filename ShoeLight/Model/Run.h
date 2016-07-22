//
//  Run.h
//  ShoeLight
//
//  Created by even on 16/3/2.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Run : NSManagedObject

+ (instancetype)runWithStartDate:(NSDate *)start
                        stopDate:(NSDate *)stop
                            step:(NSInteger)step
                        distance:(CGFloat)distance
                      isIdleMode:(BOOL)isIdleMode;

@end

NS_ASSUME_NONNULL_END

#import "Run+CoreDataProperties.h"
