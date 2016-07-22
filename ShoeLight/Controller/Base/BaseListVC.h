//
//  BaseListVC.h
//  chaShan
//
//  Created by even on 15/7/18.
//  Copyright (c) 2015年 李玉坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+Add.h"
#import "MJRefresh.h"
#import "macro.h"
#import "BaseVC.h"

@interface BaseListVC : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign,nonatomic) NSInteger page;

- (void)loadNewData;
- (void)loadMoreData;
- (void)addTableViewFooter; // 添加上拉刷新
- (void)addTableViewHeader; // 添加下拉刷新

@end
