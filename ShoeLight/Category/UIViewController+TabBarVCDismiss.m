//
//  UIViewController+TabBarVCDismiss.m
//  ShoeLight
//
//  Created by even on 16/2/14.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "UIViewController+TabBarVCDismiss.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "macro.h"

@implementation UIViewController (TabBarVCDismiss)

- (void)addDissmissBtnToLeftBarBtnItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back_n"] style:UIBarButtonItemStylePlain target:self action:@selector(showAlert)];
}


- (void)showAlert {

    BOOL needShowAlert = (kMyProfileTool.currentMode != ModeIdle);
    
    if (needShowAlert) {
        
        
        NSString *msg = [LocalTool exitMode:kMyProfileTool.currentMode];
        NSString *cancel = [LocalTool cancel];
        NSString *ok = [LocalTool ok];
        
        
        // 显示退出确认弹窗
        WEAKSELF
        [UIAlertView alertViewWithTitle:nil message:msg cancelButtonTitle:cancel otherButtonTitles:@[ok] onDismiss:^(NSInteger buttonIndex) {
            UITabBarController *tab = weakSelf.navigationController.tabBarController;
            if (tab) {
                for (UINavigationController *navVC in tab.viewControllers) {
                    UIViewController *vc = navVC.viewControllers[0];
                    if ([vc respondsToSelector:@selector(tabBarVCWillDismiss)]) {
                        [vc performSelector:@selector(tabBarVCWillDismiss) withObject:nil withObject:nil];
                    }
                }
                [tab dismissViewControllerAnimated:YES completion:nil];
            }
        } onCancel:nil];
    } else {
        // 直接退出
        UITabBarController *tab = self.navigationController.tabBarController;
        if (tab) {
            [tab dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


- (void) dismiss {
    UITabBarController *tab = self.navigationController.tabBarController;
    
    if (tab.viewControllers.count >= 4) {
        UIViewController *vc = ((UINavigationController *)tab.viewControllers[2]).viewControllers[0];
        if ([vc respondsToSelector:@selector(dismiss)]) {
            [vc performSelector:@selector(dismiss) withObject:nil withObject:nil];
        }
    } else {
        if (tab) {
            [tab dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
@end
