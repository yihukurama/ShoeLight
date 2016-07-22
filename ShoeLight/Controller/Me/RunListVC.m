//
//  RunListVC.m
//  RunLight
//
//  Created by even on 16/1/21.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "RunListVC.h"
#import "macro.h"
#import "DayPlanRun.h"
#import "DayPlanRunCell.h"
#import "RunDetailsVC.h"


@interface RunListVC ()

@end

@implementation RunListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kGlbBgColor;
    
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Exercise log" : @"运动记录";
    [self.dataSource addObjectsFromArray:[kDBManager dayPlanRuns]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RunDetailsVC"]) {
        RunDetailsVC *vc = segue.destinationViewController;
        vc.runs = sender;
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DayPlanRunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.dayPlanRun = self.dataSource[indexPath.section];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DayPlanRun *dayPlanRun = [self.dataSource objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier:@"RunDetailsVC" sender:dayPlanRun.runs];
}
@end
