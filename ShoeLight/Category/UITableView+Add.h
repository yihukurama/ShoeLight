//
//  UITableView+Add.h
//  Kido
//
//  Created by zhaoyd on 14-5-13.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Add)

- (void)setHeaderHeight:(CGFloat)height;
- (void)setFooterHeight:(CGFloat)height;

// 取消tableview空表格
- (void)setFooterWithZeroView;
@end
