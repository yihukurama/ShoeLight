//
//  BaseListVC.m
//  chaShan
//
//  Created by even on 15/7/18.
//  Copyright (c) 2015年 李玉坤. All rights reserved.
//

#import "BaseListVC.h"

@interface BaseListVC ()

@end

@implementation BaseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView setHeaderHeight:0.1];
    [self.tableView setFooterHeight:0.1];
}

#pragma mark - Public
- (void)loadNewData {}

- (void)loadMoreData {}

// 添加上拉刷新
- (void)addTableViewFooter {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.refreshingTitleHidden = YES;
    self.tableView.footer = footer;
}

// 添加下拉刷新
- (void)addTableViewHeader {
    // 上下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
}

#pragma mark - Getter
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
