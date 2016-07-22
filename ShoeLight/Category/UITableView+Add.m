//
//  UITableView+Add.m
//  Kido
//
//  Created by zhaoyd on 14-5-13.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import "UITableView+Add.h"

@implementation UITableView (Add)


- (void)setHeaderHeight:(CGFloat)height
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    self.tableHeaderView = view;
}


- (void)setFooterHeight:(CGFloat)height
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    self.tableFooterView = view;
}

// 取消tableview空表格
- (void)setFooterWithZeroView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableFooterView = view;
}

@end
