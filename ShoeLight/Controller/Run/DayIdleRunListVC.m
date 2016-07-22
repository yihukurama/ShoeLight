//
//  DayIdleRunListVC.m
//  ShoeLight
//
//  Created by even on 16/3/3.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "DayIdleRunListVC.h"
#import "DayIdleRunCell.h"
#import "macro.h"
#import "UITableView+Add.h"


@interface DayIdleRunListVC ()

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation DayIdleRunListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.backgroundColor = kGlbBgColor;
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Other Steps" : @"闲时计步";
    
    self.dataSource = [kDBManager dayIdleRuns];
    [self.tableView setHeaderHeight:0.1];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId  = @"Cell";
    DayIdleRunCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.dayIdleRun = self.dataSource[indexPath.section];
    return cell;
}



@end
