//
//  AlarmListVC.m
//  ShoeLight
//
//  Created by even on 16/3/4.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "AlarmListVC.h"
#import "macro.h"
#import "AudioTool.h"
#import "AlarmTool.h"

@interface AlarmListVC ()

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation AlarmListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kGlbBgColor;
    
    if (kMyProfileTool.isEnglish) {
        self.dataSource = [self englishDataSource];
        self.navigationItem.title = @"Alarm";
    } else {
        self.dataSource = [self chineseDataSource];
    }
}


- (NSArray *)chineseDataSource {
    return @[@"格桑花开",@"韩国非主流歌",@"和弦彩铃",@"日语铃声",
             @"银笛",@"自由飞翔",@"loving_u",@"迪吧舞曲",@"铃声之家",@"清新女声",@"情书",@"舞曲狂潮",@"乡村爱情",@"月光女神",@"最炫小苹果",@"see_you_again"];
}

- (NSArray *)englishDataSource {
    return @[@"kelsang_flowers",@"non_mainstream_korean",@"polyphonic_ring_tones",@"japanese_ringtone",@"silver_whistle",@"free_to_fly",@"loving_u",@"disco_dance",@"ringtones_house",@"fresh_girl",@"love_letter",@"dance_craze",@"country_love",@"la_luna",@"coolest_small_apple",@"see_you_again"];
}

- (void)dealloc {
    [kAlarmTool stopPlay];
    [kNotificationCenter postNotificationName:kAlarmEndPlayNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId  = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = kWhiteColor;
    
    NSString *alarm = self.dataSource[indexPath.row];
    cell.textLabel.text = alarm;
    cell.accessoryType = [kAlarmTool.alarm integerValue] == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    kAlarmTool.alarm = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    kAlarmTool.chineseAlarmName = [self chineseDataSource][indexPath.row];
    kAlarmTool.englishAlarmName = [self englishDataSource][indexPath.row];
    [kAlarmTool playAlarm:kAlarmTool.alarm times:1];
    
    [self.tableView reloadData];
}

@end
