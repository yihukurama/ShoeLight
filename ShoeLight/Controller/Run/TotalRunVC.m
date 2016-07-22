//
//  TotalRunVC.m
//  ShoeLight
//
//  Created by even on 16/2/23.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "TotalRunVC.h"
#import "RunDetailView.h"
#import <Masonry.h>
#import "macro.h"
#import "RunDataView.h"

@interface TotalRunVC ()

@property (weak, nonatomic) RunDetailView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *idleHistoryBtn;

@end

@implementation TotalRunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kGlbBgColor;
    
    self.detailView = [RunDetailView runDetailView];
    self.detailView.isTotal = YES;
    
    [self.view addSubview:self.detailView];
    
    // 加约束，否则位置不对
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 310));
    }];
    
    self.idleHistoryBtn.layer.cornerRadius = 5;
    self.idleHistoryBtn.layer.borderColor = kGetColorFromHex(0xfc4851, 1).CGColor;
    self.idleHistoryBtn.layer.borderWidth = 1;
    self.idleHistoryBtn.layer.masksToBounds = YES;
    [self.idleHistoryBtn setTitleColor:kGetColorFromHex(0xfc4851, 1) forState:UIControlStateNormal];
    [self updateLanguage];
    
    self.detailView.step = kMyProfileTool.totalStep;
    self.detailView.runDataView.distenceLbl.text = [NSString stringWithFormat:@"%.2f",kMyProfileTool.totalDistance * 0.001];
    
    if (kMyProfileTool.totalTime) {
        self.detailView.runDataView.speedLbl.text = [NSString stringWithFormat:@"%.2f",(CGFloat)kMyProfileTool.totalDistance / kMyProfileTool.totalTime];
        self.detailView.runDataView.timeLbl.text = [CommonTool hhmmssStrWithTimeInterval:kMyProfileTool.totalTime];
    }
    self.detailView.runDataView.calorieLbl.text = [CommonTool caloriesStrWithDistance:kMyProfileTool.totalDistance];
}

- (void)updateLanguage {
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"All Records" : @"累积记录";
    [self.detailView updateLanguage];
    [self.idleHistoryBtn setTitle:kMyProfileTool.isEnglish ? @"Check other steps" : @"查看闲时计步" forState:UIControlStateNormal];
}

@end
