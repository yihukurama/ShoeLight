//
//  AppDelegate.m
//  BLELight
//
//  Created by even on 16/1/1.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "AppDelegate.h"
#import "macro.h"
#import <MobClick.h>

#import <AVFoundation/AVFoundation.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [kBLE startScan];
    [MobClick startWithAppkey:@"57343160e0f55a70c30002e6" reportPolicy:BATCH channelId:@"Dev"];
    
    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                             sizeof (doChangeDefaultRoute),
                             &doChangeDefaultRoute
                             );
    [kDBManager openDBWithUserId:@"One"];
    
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
    [application registerUserNotificationSettings:setting];
    
    [self showStoryboard];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [kDBManager save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [kDBManager save];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
}

- (void)showStoryboard
{
    // 取出当前引导页面版本，以及播放过的引导页面版本
    NSString *guideVersionKey = @"CFBundleGuideVersionString";
    NSString *currentGuideVersion = [NSBundle mainBundle].infoDictionary[guideVersionKey];
    NSString *playedGuideVersion = [kUserDefaults objectForKey:guideVersionKey];
    
    // 播放的引导版本和plist中的当前引导界面版本一致，代表以前播放过向导页面
    BOOL needShowGuide = ![playedGuideVersion isEqualToString:currentGuideVersion];
    if (!needShowGuide) {
        [self showStoryboardWithName:@"Main"];
    } else {
        // 代表以前没播放过向导页面
        [self showStoryboardWithName:@"Guide"];
    }
}

#pragma mark - Public
// 根据名字显示不同的故事板x
- (void)showStoryboardWithName:(NSString *)storyboardName
{
    // 1.选择storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    // 2.显示到window
    if (_window == nil) {
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    [_window setRootViewController:storyboard.instantiateInitialViewController];
    if (![_window isKeyWindow]) {
        [_window makeKeyAndVisible];
    }
}

@end
