//
//  UIView+BgColor.h
//  Kido
//
//  Created by zhaoyd on 14-5-15.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Add)

// 为view添加退出键盘手势
- (void)addResignFirstResponderGesture;

// 为view删除退出键盘手势
- (void)removeResignFirstResponderGesture;

// 移除所有手势
- (void)removeAllGestureRecognizers;

// 获取view所在的控制器
- (UIViewController *) viewControllerWithClassName:(NSString *)className;

@end
