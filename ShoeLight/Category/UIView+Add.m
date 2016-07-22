//
//  UIView+BgColor.m
//  Kido
//
//  Created by zhaoyd on 14-5-15.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import "UIView+Add.h"



@implementation UIView (Add)


// 为view添加退出键盘手势
- (void)addResignFirstResponderGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];
    
}


// 为view删除退出键盘手势
- (void)removeResignFirstResponderGesture
{
    for (UIGestureRecognizer *gest in self.gestureRecognizers) {
        if ([gest isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:gest];
        }
    }
}


- (void)tapView
{
    [self endEditing:YES];
}


- (void)removeAllGestureRecognizers
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
}


// 获取view所在的控制器
- (UIViewController *) viewControllerWithClassName:(NSString *)className
{
    UIView *nexta = [self superview];
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:NSClassFromString(className)]) {
            return (UIViewController *)nextResponder;
        }
    }
    
    NSLog(@"没有找到view的导航控制器");
    return nil;
}
@end
