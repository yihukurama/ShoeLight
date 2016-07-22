//
//  GuideVC.m
//  NewGS
//
//  Created by newgs_mac on 15/1/30.
//  Copyright (c) 2015年 cnmobi. All rights reserved.
//

#import "GuideVC.h"
#import "macro.h"
#import "AlarmTool.h"
#import "NavigationVC.h"
#import "PersonInfoVC.h"

@interface GuideVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWCons;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIImageView *imageView0;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;


@property (weak, nonatomic) IBOutlet UIButton *beginBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgContentView0WCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgContentView1WCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgContentView2WCons;



@end

@implementation GuideVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureSubviews];
    
    kAlarmTool.isOn = YES;
    kAlarmTool.time = 1;
    kAlarmTool.alarm = @"0";
    kAlarmTool.englishAlarmName = @"kelsang_flowers";
    kAlarmTool.chineseAlarmName = @"格桑花开";
    kAlarmTool.volume = 0.5;
    kAlarmTool.distanceAlarmIsOn = NO;
    kAlarmTool.timeAlarmIsOn = NO;
}

- (void)configureSubviews
{
    self.scrollView.delegate = self;
    self.contentViewHConstraint.constant = kScreenHeight;
    self.contentViewWCons.constant = kScreenWidth * 3;
    
    [self.beginBtn setBackgroundColor:kWhiteColor];
    
//    CGFloat bottomSpace = (kScreenHeight == 480) ? 40 : 100;

    
    self.imgContentView0WCons.constant = kScreenWidth;
    self.imgContentView1WCons.constant = kScreenWidth;
    self.imgContentView2WCons.constant = kScreenWidth;
    
    
    
    if (kScreenHeight == 480) {
        self.imageView0.image = [UIImage imageNamed:@"guide1_4S"];
        self.imageView1.image = [UIImage imageNamed:@"guide2_4S"];
        self.imageView2.image = [UIImage imageNamed:@"guide3_4S"];
    } else if (kScreenHeight == 568) {
        self.imageView0.image = [UIImage imageNamed:@"guide1_5"];
        self.imageView1.image = [UIImage imageNamed:@"guide2_5"];
        self.imageView2.image = [UIImage imageNamed:@"guide3_5"];
    } else if (kScreenHeight == 667) {
        self.imageView0.image = [UIImage imageNamed:@"guide1_6"];
        self.imageView1.image = [UIImage imageNamed:@"guide2_6"];
        self.imageView2.image = [UIImage imageNamed:@"guide3_6"];
    } else if (kScreenHeight == 736) {
        self.imageView0.image = [UIImage imageNamed:@"guide1_6+"];
        self.imageView1.image = [UIImage imageNamed:@"guide2_6+"];
        self.imageView2.image = [UIImage imageNamed:@"guide3_6+"];
    }
    
    self.pageControl.hidden = NO;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Action
- (IBAction)beginBtnClicked:(id)sender
{
//    [kAppDelegate showStoryboardWithName:@"Main"];
    PersonInfoVC *info = [kMainStoryboard instantiateViewControllerWithIdentifier:@"PersonInfoVC"];
    info.isGuide = YES;
    NavigationVC *navi = [[NavigationVC alloc]initWithRootViewController:info];
    [self presentViewController:navi animated:YES completion:nil];
}


#pragma mark - UIScrollView 代理 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = round(scrollView.contentOffset.x / (CGFloat)kScreenWidth);
}

@end
