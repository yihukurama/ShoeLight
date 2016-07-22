//
//  CoreDataTool.h
//  SmartSocket
//
//  Created by zhaoyd on 14-7-23.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//  coreData数据库管理

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <CoreData/CoreData.h>

@class Run;

@interface DBManager : NSObject
single_interface(DBManager)


// coreData上下文
@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

// 创建/打开数据库 切换帐户，登录后要调用一下
- (void)openDBWithUserId:(NSString *)userId;
// 保存context中变化的内容
- (BOOL)save;

/* 取出所有的用户计划的运动记录 */
- (NSArray *)dayPlanRuns;

/* 取出所有的闲时运动记录 */
- (NSArray *)dayIdleRuns;


#pragma mark - 通用
// 删除符合条件的某些对象
- (void)deleteManagedObjectsWithEntityName:(NSString *)entityName andPredicate:(NSPredicate *)predicate;

// 取出符合条件的某些对象
- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName andPredicate:(NSPredicate *)predicate;

// 取出符合条件的某些对象
- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName
                                  andPredicate:(NSPredicate *)predicate
                               sortDescriptors:(NSArray *)sortDescriptors;

// 把str里的“[T]”与“[/T]”替换成“#”
- (NSString *)replacePoundSignStr:(NSString *)str;
@end
