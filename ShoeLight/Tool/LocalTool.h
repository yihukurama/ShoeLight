//
//  LocalTool.h
//  ShoeLight
//
//  Created by even on 16/4/27.
//  Copyright © 2016年 Aiden. All rights reserved.
//  语言本地化工具

#import <Foundation/Foundation.h>
#import "macro.h"


@interface LocalTool : NSObject

+ (NSString *)leftShoeConnected;
+ (NSString *)rightShoeConnected;
+ (NSString *)leftShoeDisconnected;
+ (NSString *)rightShoeDisconnected;

+ (NSString *)shoesNeedToConnect;
+ (NSString *)leftShoeNeedToConnect;
+ (NSString *)rightShoeNeedToConnect;

+ (NSString *)toCurrentModeWillExitMode:(Mode)mode;
+ (NSString *)exitMode:(Mode)mode;

+ (NSString *)runReachHalfTime;
+ (NSString *)runReachFullTime;
+ (NSString *)runReachHalfDistance;
+ (NSString *)runReachFullDistance;

+ (NSString *)oneLeftShoeMost;
+ (NSString *)oneRightShoeMost;

+ (NSString *)ok;
+ (NSString *)cancel;
+ (NSString *)close;
@end
