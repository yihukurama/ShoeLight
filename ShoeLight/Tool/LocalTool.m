//
//  LocalTool.m
//  ShoeLight
//
//  Created by even on 16/4/27.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#define kLocalString(chinese,english)  (kMyProfileTool.isEnglish ?  english : chinese)

#import "LocalTool.h"

@implementation LocalTool

#pragma mark - Public
+ (NSString *)leftShoeConnected {
    return kLocalString(@"左鞋连接成功", @"Successfully connected with left shoe");
}
+ (NSString *)rightShoeConnected {
    return kLocalString(@"右鞋连接成功", @"Successfully connected with right shoe");
}
+ (NSString *)leftShoeDisconnected {
    return kLocalString(@"左鞋断开", @"Disconnected with left shoe");
}
+ (NSString *)rightShoeDisconnected {
    return kLocalString(@"右鞋断开", @"Disconnected with right shoe");
}

+ (NSString *)shoesNeedToConnect {
    return kLocalString(@"请连接闪光鞋", @"Please connect with shoes");
}
+ (NSString *)leftShoeNeedToConnect {
    return kLocalString(@"请连接左鞋", @"Please connect with left shoe");
}
+ (NSString *)rightShoeNeedToConnect {
    return kLocalString(@"请连接右鞋", @"Please connect with right shoe");
}

+ (NSString *)toCurrentModeWillExitMode:(Mode)mode {
    
    return kLocalString(@"进入当前模式，其它模式将退出", @"Enter the current mode, and the other mode exits");
//    NSString *preStr = kLocalString(@"进入当前模式，", @"Enter the current mode, and ");
//    NSString *modeStr = [self mode:mode];
//    NSString *suffixStr = kLocalString(@"将退出", @" exits");
//    return [NSString stringWithFormat:@"%@%@%@",preStr,modeStr,suffixStr];
}

+ (NSString *)exitMode:(Mode)mode {
    NSString *preStr = kLocalString(@"退出", @"Exit ");
    NSString *modeStr = [self mode:mode];
    return [NSString stringWithFormat:@"%@%@",preStr,modeStr];
}

+ (NSString *)runReachHalfTime {
    return kLocalString(@"您已经运动了设定时间的一半", @"Your exercise has reached half of the set time");
}
+ (NSString *)runReachFullTime {
    return kLocalString(@"您已经运动达到设定的时长", @"Your exercise has reached the set time");
}
+ (NSString *)runReachHalfDistance {
    return kLocalString(@"您已经运动了设定里程的一半", @"Your exercise has reached half of the set mileage");
}
+ (NSString *)runReachFullDistance {
    return kLocalString(@"您已经运动达到设定的里程", @"Your exercise has reached the set mileage");
}

+ (NSString *)oneLeftShoeMost {
    return kLocalString(@"最多只能连接一个左鞋蓝牙", @"Can only connect with Bluetooth of one left shoe at most");
}
+ (NSString *)oneRightShoeMost {
    return kLocalString(@"最多只能连接一个右鞋蓝牙", @"Can only connect with Bluetooth of one right shoe at most");
}

+ (NSString *)ok {
    return kLocalString(@"确定", @"OK");
}
+ (NSString *)cancel {
    return kLocalString(@"取消", @"Cancel");
}
+ (NSString *)close {
    return kLocalString(@"关闭", @"Close");
}
#pragma mark - Private
+ (NSString *)mode:(Mode)mode {
    switch (mode) {
        case ModeLight:
            return kLocalString(@"炫彩模式", @"color mode");
            break;
        case ModeMusic:
            return kLocalString(@"音乐模式", @"music mode");
            break;
        case ModeRun:
            return kLocalString(@"运动模式", @"sport mode");
            break;
        default:
            return @"";
            break;
    }
}
@end
