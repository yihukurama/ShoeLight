//
//  CoreDataTool.m
//  SmartSocket
//
//  Created by zhaoyd on 14-7-23.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import "DBManager.h"
#import <objc/runtime.h>
#import "macro.h"
#import "Run.h"
#import "DayPlanRun.h"
#import "DayIdleRun.h"

#define kAssociationContextNameKey  @"ContextName"

@implementation DBManager
single_implementation(DBManager)

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

// 创建/打开数据库 切换帐户，登录后或者后台登录时必须要调用一下
- (void)openDBWithUserId:(NSString *)userId
{
    NSString *contextName = objc_getAssociatedObject(_context, kAssociationContextNameKey);
    if ([contextName isEqualToString:userId]) {
        return;
    } else if (_context) {
        [self save];
    }
    
    // 1.取出合并的数据模型
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 2.建立存储协调者
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    // 3.协调者创建/打开文件
//    if (![kFileManager fileExistsAtPath:kAccountFile]) {
//        [kFileManager createDirectoryAtPath:kAccountFile withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    NSString *path = [kDocDir stringByAppendingPathComponent:@"Run.db"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    
    // 4.上下文与存储协调者关联
    if (error) {
        NSLog(@"打开数据库出错 - %@", error.localizedDescription);
        
        // 4.1 删除数据库
        // 取出所有要删的newgs.db的文件路径
        NSArray *pathArray = [kFileManager subpathsOfDirectoryAtPath:kDocDir error:nil];
        NSMutableArray *filesToDelete = [NSMutableArray array];
        for (NSString *path in pathArray) {
            if ([path containsString:@"Run.db"]) {
                [filesToDelete addObject:[kDocDir stringByAppendingPathComponent:path]];
            }
        }
        
        // 删除所有文件
        for (NSString *path in filesToDelete) {
            if ([kFileManager fileExistsAtPath:path]) {
                [kFileManager removeItemAtPath:path error:nil];
            }
        }
        
        // 重新打开数据库
        [self openDBWithUserId:userId];
        
    } else {
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = store;
        objc_setAssociatedObject(_context, kAssociationContextNameKey, userId, OBJC_ASSOCIATION_COPY);
    }
}

// 保存修改
- (BOOL)save
{
    if (nil == _context) {
        MyLog(@"数据库ManagedObjectContext为空!!!");
        return 0;
    }
    
    NSError *error = nil;
    if ([_context hasChanges] && ![_context save:&error]) {
        MyLog(@"coreData保存出错%@",error);
        return 0;
    } else {
        return 1;
    }
}


- (NSArray *)dayIdleRuns {
    NSMutableArray *dayIdleRuns = [NSMutableArray array];
    
    // 取出所有的闲时记录
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isIdleMode == %@",@(YES)];
    NSArray *idleRuns = [self fetchManagedObjectsWithEntityName:@"Run" andPredicate:predicate sortDescriptors:@[sortDescriptor]];
    
    for (int i = 0; i < idleRuns.count; i ++) {
        Run *run = idleRuns[i];
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:run.startDate];
        if (i == 0) {
            DayIdleRun *dayIdleRun = [[DayIdleRun alloc]init];
            dayIdleRun.date = startDate;
            dayIdleRun.totalStep = run.step;
            dayIdleRun.totalDistance = run.distance;
            [dayIdleRuns addObject:dayIdleRun];
            
        } else {
            DayIdleRun *lastDayIdleRun = [dayIdleRuns lastObject];
            if ([self isSameDayWithDate:lastDayIdleRun.date andDate:startDate]) {
                // 和前面的是同一天，则把数据加上去
                lastDayIdleRun.totalStep += run.step;
                lastDayIdleRun.totalDistance += run.distance;
            } else {
                // 不是同一天，新建一个对象
                DayIdleRun *dayIdleRun = [[DayIdleRun alloc]init];
                dayIdleRun.date = startDate;
                dayIdleRun.totalStep = run.step;
                dayIdleRun.totalDistance = run.distance;
                [dayIdleRuns addObject:dayIdleRun];
            }
        }
    }
    
    return dayIdleRuns;
}

- (NSArray *)dayPlanRuns {
    NSMutableArray *dayPlanRuns = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isIdleMode == %@",@(NO)];
    NSArray *planRuns = [self fetchManagedObjectsWithEntityName:@"Run" andPredicate:predicate sortDescriptors:@[sortDescriptor]];
    
    
    for (int i = 0; i < planRuns.count; i ++) {
        Run *run = planRuns[i];
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:run.startDate];
        if (i == 0) {
            DayPlanRun *dayPlanRun = [[DayPlanRun alloc]init];
            dayPlanRun.date = startDate;
            dayPlanRun.totalStep = run.step;
            dayPlanRun.runs = [NSMutableArray arrayWithObject:run];
            [dayPlanRuns addObject:dayPlanRun];
            
        } else {
            DayPlanRun *lastDayPlanRun = [dayPlanRuns lastObject];
            if ([self isSameDayWithDate:lastDayPlanRun.date andDate:startDate]) {
                // 和前面的是同一天，则把数据加上去
                lastDayPlanRun.totalStep += run.step;
                [lastDayPlanRun.runs addObject:run];
            } else {
                // 不是同一天，新建一个对象
                DayPlanRun *dayPlanRun = [[DayPlanRun alloc]init];
                dayPlanRun.date = startDate;
                dayPlanRun.totalStep = run.step;
                dayPlanRun.runs = [NSMutableArray arrayWithObject:run];
                [dayPlanRuns addObject:dayPlanRun];
            }
        }
    }
    
    return dayPlanRuns;
}

#pragma mark - 通用
// 删除符合条件的某些对象
- (void)deleteManagedObjectsWithEntityName:(NSString *)entityName andPredicate:(NSPredicate *)predicate
{
    NSArray *tmpArray = [self fetchManagedObjectsWithEntityName:entityName andPredicate:predicate];
    
    if (tmpArray && [tmpArray count]) {
        for (NSManagedObject *obj in tmpArray) {
            [_context deleteObject:obj];
        }
        [self save];
    }
}

// 取出符合条件的某些对象
- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName andPredicate:(NSPredicate *)predicate
{
    return [self fetchManagedObjectsWithEntityName:entityName andPredicate:predicate sortDescriptors:nil];
}


// 取出符合条件的某些对象
- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName
                                  andPredicate:(NSPredicate *)predicate
                               sortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetch.predicate = predicate;
    fetch.sortDescriptors = sortDescriptors;
    
    NSError *error = nil;
    NSArray *array = [_context executeFetchRequest:fetch error:&error];
    if (error) {
        MyLog(@"查询%@出错,%@",entityName,error.localizedDescription);
    }
    
    if (!error && array && [array count]) {
        return array;
    } else {
        return [NSArray array];
    }
}


// 判断两个date是不是在一天
- (BOOL)isSameDayWithDate:(NSDate *)date0 andDate:(NSDate *)date1 {
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    if (
        (int)(([date0 timeIntervalSince1970] + timezoneFix)/(24*3600)) -
        (int)(([date1 timeIntervalSince1970] + timezoneFix)/(24*3600))
        == 0)
    {
        return YES;
    }
    return NO;
}

@end
