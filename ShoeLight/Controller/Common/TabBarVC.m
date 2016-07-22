//
//  TabBarVC.m
//  ShoeLight
//
//  Created by even on 16/2/13.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "TabBarVC.h"
#import "macro.h"

@interface TabBarVC ()

@end

@implementation TabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = kGetColorFromHex(0xFC4851, 1);
    self.tabBar.barTintColor = kGetColorFromHex(0x26282c, 1);
    self.tabBar.translucent = NO;
    
    [self updateLanguage];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UINavigationController *navi = self.viewControllers[0];
    
    [kBLE setBleDelegate:navi.viewControllers[0]];
//    for (UINavigationController *vc in self.viewControllers) {
//        [vc.viewControllers[0] view];
//    }
}
- (void)updateLanguage {
    
    UINavigationController *runNavi = self.viewControllers[0];
    UINavigationController *colorNavi = self.viewControllers[1];
    UINavigationController *musicNavi = self.viewControllers[2];
    UINavigationController *meNavi = self.viewControllers[3];
    
    if (kMyProfileTool.isEnglish) {
        runNavi.tabBarItem.title = @"Sports";
        colorNavi.tabBarItem.title = @"Color";
        musicNavi.tabBarItem.title = @"Music";
        meNavi.tabBarItem.title = @"Mine";
    } else {
        runNavi.tabBarItem.title = @"运动";
        colorNavi.tabBarItem.title = @"炫彩";
        musicNavi.tabBarItem.title = @"音乐";
        meNavi.tabBarItem.title = @"我的";
        
    }
    
    
}



@end
