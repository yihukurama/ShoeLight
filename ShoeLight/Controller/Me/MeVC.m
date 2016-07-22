//
//  MeVC.m
//  ShoeLight
//
//  Created by even on 16/2/13.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "MeVC.h"
#import "UITableView+Add.h"
#import "macro.h"
#import "UIViewController+TabBarVCDismiss.h"

@interface MeVC ()
@property (weak, nonatomic) IBOutlet UILabel *personInfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *alarmTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *aboutUsLbl;

@end

@implementation MeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setHeaderHeight:0.1];
    
    self.tableView.backgroundColor = kGlbBgColor;
    [self updateLanguage];
    [self addRightBarBtnItem];
    
    [self addDissmissBtnToLeftBarBtnItem];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)updateLanguage {
    self.personInfoLbl.text = kMyProfileTool.isEnglish ? @"Personal Information" : @"个人信息";
    self.alarmTypeLbl.text = kMyProfileTool.isEnglish ? @"Alarm" : @"闹铃方式";
    self.aboutUsLbl.text = kMyProfileTool.isEnglish ? @"About Us" : @"关于我们";
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Mine" : @"我的";
}

- (void)addRightBarBtnItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:kMyProfileTool.isEnglish ? @"Bluetooth Set" : @"蓝牙设置" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnItemClicked)];
}

- (void)rightBarBtnItemClicked {
    [self performSegueWithIdentifier:@"BLEListVC" sender:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
