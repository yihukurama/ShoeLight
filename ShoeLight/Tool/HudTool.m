//
//  HudTool.m
//
//
//  Created by zhaoyd on 14-7-2.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import "HudTool.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "macro.h"

@interface HudTool() <MBProgressHUDDelegate>
{
    MBProgressHUD *_hud;
}
@end

@implementation HudTool
single_implementation(HudTool)

#pragma mark -
#pragma mark  MBProgressHUD
// 显示hudg正在加载中，并提示文字
- (void)showHudWithLoadingText:(NSString *)text
{
    if (_hud) {
        // 如果存在，就隐藏
        [_hud hide:NO];
    } else {
        // 如果不存在，实例化一个
        _hud = [[MBProgressHUD alloc]initWithView:[kAppDelegate window]];
       
        _hud.delegate = self;
        NSLog(@"hud被创建了一次");
    }
    
    if (text) {
        _hud.detailsLabelText = text;
    } else {
        _hud.detailsLabelText = nil;
    }
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.dimBackground = NO;
    [[kAppDelegate window] addSubview:_hud];
    [_hud show:YES];
}

// 显示hudg正在加载中，并提示文字 ,仅加载到当前页面
- (void)showHudWithLoadingText:(NSString *)text inView:(UIView *)view
{
    if (!view) {
        return;
    }
    if (_hud) {
        // 如果存在，就隐藏
        [_hud hide:NO];
    } else {
        // 如果不存在，实例化一个
        _hud = [[MBProgressHUD alloc]initWithView:view];
        
        _hud.delegate = self;
        NSLog(@"hud被创建了一次");
    }
    
    if (text) {
        _hud.detailsLabelText = text;
    } else {
        _hud.detailsLabelText = nil;
    }
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.dimBackground = NO;
    [view addSubview:_hud];
    [_hud show:YES];
}

//// 显示1秒钟的hud文字提示
- (void)showHudOneSecondWithText:(NSString *)text
{
    
    if (_hud) {
        // 如果存在，就隐藏
        [_hud hide:NO];
    } else {
        // 如果不存在，实例化一个
        _hud = [[MBProgressHUD alloc]initWithView:[kAppDelegate window]];
        _hud.delegate = self;
        NSLog(@"hud被创建了一次");
    }
    
    _hud.mode = MBProgressHUDModeText;
    _hud.detailsLabelText = text;
    _hud.dimBackground = NO;
    [[kAppDelegate window] addSubview:_hud];
    [_hud show:YES];
    [_hud hide:YES afterDelay:1.0f];
}

// 显示1秒钟的hud文字提示 ,仅加载到当前页面
- (void)showHudOneSecondWithText:(NSString *)text inView:(UIView *)view
{
    if (!view) {
        return;
    }
    if (_hud) {
        // 如果存在，就隐藏
        [_hud hide:NO];
    } else {
        // 如果不存在，实例化一个
        _hud = [[MBProgressHUD alloc]initWithView:view];
        _hud.delegate = self;
        NSLog(@"hud被创建了一次");
    }
    
    _hud.mode = MBProgressHUDModeText;
    _hud.detailsLabelText = text;
    _hud.dimBackground = NO;
    [view addSubview:_hud];
    [_hud show:YES];
    [_hud hide:YES afterDelay:1.0f];
}

// 隐藏移除hud,并nil
- (void)hideHudWithAnimation:(BOOL)animated
{
    if (_hud != nil && ![_hud isHidden]) {
        [_hud hide:animated];
    }
}

#pragma mark  MBProgressHUD代理方法
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    _hud.labelText = nil;
    [_hud removeFromSuperview];
}
@end
