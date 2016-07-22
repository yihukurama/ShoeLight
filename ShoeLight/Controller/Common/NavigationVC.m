//
//  NavigationVC.m
//  ShoeLight
//
//  Created by even on 16/2/17.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "NavigationVC.h"
#import "macro.h"

@interface NavigationVC () <UINavigationControllerDelegate>

@end

@implementation NavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUINavigationBarAppearence];
    self.delegate = self;
}

// 设置导航栏全局样式
- (void)setUINavigationBarAppearence
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    // 1.导航栏title属性
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 2.导航栏颜色
    [navigationBar setBarTintColor:kGetColorFromHex(0x292c30, 1)];
    [navigationBar setTintColor:[UIColor whiteColor]];
    
    // 3.导航栏item
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    NSDictionary *dict = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateDisabled];
    
//    // 4.返回按钮
//    self.navigationBar.userInteractionEnabled = YES;
//    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"btn_navi_back"];
//    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"btn_navi_back"];
    self.navigationBar.translucent = NO;
}


#pragma mark - UINavigationViewController 代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 去除返回按钮上的文字
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
