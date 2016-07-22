//
//  Run+CoreDataProperties.h
//  ShoeLight
//
//  Created by even on 16/3/2.
//  Copyright © 2016年 Aiden. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Run.h"

NS_ASSUME_NONNULL_BEGIN

@interface Run (CoreDataProperties)

@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) NSTimeInterval stopDate;
@property (nonatomic) int32_t step;
@property (nonatomic) float distance;
@property (nonatomic) BOOL isIdleMode;

@end

NS_ASSUME_NONNULL_END
