//
//  CommonTool.m
//  ShoeLight
//
//  Created by even on 16/3/2.
//  Copyright © 2016年 Aiden. All rights reserved.
//


#import "CommonTool.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "macro.h"

@implementation CommonTool

// 将秒转换为mm:ss格式的字符串
+ (NSString *)mmssStrWithTimeInterval:(NSTimeInterval)interval
{
    int m = interval / 60;
    int s = (int)interval % 60;
    return [NSString stringWithFormat:@"%02d:%02d", m , s];
}

// 将秒转换为hh:mm:ss格式的字符串
+ (NSString *)hhmmssStrWithTimeInterval:(NSTimeInterval)interval
{
    int h = interval / 3600;
    int m = interval / 60 - h * 60;
    int s = (int)interval % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m , s];
}

+ (NSString *)caloriesStrWithDistance:(CGFloat)distance {
    return [NSString stringWithFormat:@"%.0f",distance * 0.001 * kMyProfileTool.weight * 1.036];
}

//浮点数处理并去掉多余的0
+ (NSString *)stringDisposeWithFloat:(float)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%f",floatValue];
    long len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}



// 如果当前的模式不是运动模式，就执行这个block,如果是，就弹出一个alertview,提示用户是否关闭运动模式，如果关闭了，就再执行这个block
+ (void)excuteBlockInLightMode:(VoidBlock)block {
//    if (kMyProfileTool.currentMode == ModeRun) {
//        [UIAlertView alertViewWithTitle:nil message:@"进入当前模式，其他模式将退出" cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出"] onDismiss:^(NSInteger buttonIndex) {
//            // 关闭
//            kMyProfileTool.currentMode = ModeMusic;
//            if(block) {
//                block();
//            }
//            
//        } onCancel:nil];
//    }
//    
//    else
        if (kMyProfileTool.currentMode == ModeMusic) {

        [UIAlertView alertViewWithTitle:nil message:[LocalTool toCurrentModeWillExitMode:ModeMusic] cancelButtonTitle:[LocalTool cancel] otherButtonTitles:@[[LocalTool close]] onDismiss:^(NSInteger buttonIndex) {
            // 关闭
            kMyProfileTool.currentMode = ModeLight;
            if(block) {
                block();
            }
            
        } onCancel:nil];
    }
    
    else {
        if(block) {
            block();
        }
    }
}



+ (void)excuteBlockInMusicMode:(VoidBlock)block {
    if (kMyProfileTool.currentMode == ModeRun) {
        [UIAlertView alertViewWithTitle:nil message:[LocalTool toCurrentModeWillExitMode:ModeRun] cancelButtonTitle:[LocalTool cancel] otherButtonTitles:@[[LocalTool close]] onDismiss:^(NSInteger buttonIndex) {
            // 关闭
            kMyProfileTool.currentMode = ModeMusic;
            if(block) {
                block();
            }
            
        } onCancel:nil];
    }
    else if (kMyProfileTool.currentMode == ModeLight) {
        [UIAlertView alertViewWithTitle:nil message:[LocalTool toCurrentModeWillExitMode:ModeLight] cancelButtonTitle:[LocalTool cancel] otherButtonTitles:@[[LocalTool close]] onDismiss:^(NSInteger buttonIndex) {
            // 关闭
            kMyProfileTool.currentMode = ModeMusic;
            if(block) {
                block();
            }
            
        } onCancel:nil];
    }
    else {
        if(block) {
            block();
        }
    }
}


+ (void)excuteBlockInRunMode:(VoidBlock)block {
//    if (kMyProfileTool.currentMode == ModeMusic) {
//        [UIAlertView alertViewWithTitle:nil message:@"进入当前模式，其他模式将退出" cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出"] onDismiss:^(NSInteger buttonIndex) {
//            // 关闭
//            kMyProfileTool.currentMode = ModeRun;
//            if(block) {
//                block();
//            }
//            
//        } onCancel:nil];
//    } else
    
        if (kMyProfileTool.currentMode == ModeMusic) {
        [UIAlertView alertViewWithTitle:nil message:[LocalTool toCurrentModeWillExitMode:ModeMusic] cancelButtonTitle:[LocalTool cancel] otherButtonTitles:@[[LocalTool close]] onDismiss:^(NSInteger buttonIndex) {
            // 关闭
            kMyProfileTool.currentMode = ModeRun;
            if(block) {
                block();
            }
            
        } onCancel:nil];
    } else {
        if(block) {
            block();
        }
    }
}


@end
