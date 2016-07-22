//
//  HudTool.h
//  
//
//  Created by zhaoyd on 14-7-2.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <UIKit/UIKit.h>

@interface HudTool : NSObject
single_interface(HudTool)

// 显示1秒钟的hud文字提示
- (void)showHudOneSecondWithText:(NSString *)text;
//  显示1秒钟的hud文字提示,添加当前视图上
- (void)showHudOneSecondWithText:(NSString *)text inView:(UIView *)view;



// 隐藏移除hud,并nil
- (void)hideHudWithAnimation:(BOOL)animated;

// 显示hud正在加载中，并提示文字
- (void)showHudWithLoadingText:(NSString *)text;
// 显示hud正在加载中，并提示文字,添加当前视图上
- (void)showHudWithLoadingText:(NSString *)text inView:(UIView *)view;

@end
