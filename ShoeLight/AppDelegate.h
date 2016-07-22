//
//  AppDelegate.h
//  BLELight
//
//  Created by even on 16/1/1.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


// 根据名字显示不同的故事板x
- (void)showStoryboardWithName:(NSString *)storyboardName;
@end

