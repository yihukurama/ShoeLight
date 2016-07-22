//
//  RunDetailsVC.m
//  ShoeLight
//
//  Created by even on 16/2/14.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "RunDetailsVC.h"
#import "macro.h"
#import "RunDetailView.h"
#import "UIView+Frame.h"
#import "Masonry.h"
#import "Run.h"

@interface RunDetailsVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWCons;

@end

@implementation RunDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.contentViewHCons.constant = kScreenHeight - 100;
    self.contentViewWCons.constant = kScreenWidth * self.runs.count;
    [self addRunDetailViews];
    
    self.pageCtrl.numberOfPages = self.runs.count;
    if (self.runs.count <= 1) {
        self.pageCtrl.hidden = YES;
    } else {
        self.pageCtrl.hidden = NO;
    }
    
    self.contentView.backgroundColor = kGlbBgColor;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Exercise details" : @"运动详情";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)addRunDetailViews {
    for (int i = 0; i < self.runs.count; i ++) {

        RunDetailView *view = [RunDetailView runDetailView];
        [self.contentView addSubview:view];
        view.run = self.runs[i];
        [view updateLanguage];
        
        // 加约束，否则位置不对
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.left.equalTo(self.contentView.mas_left).with.offset(i * kScreenWidth);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
        }];
    }
}


#pragma mark - UIScrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageCtrl.currentPage = round(scrollView.contentOffset.x / (CGFloat)kScreenWidth);
}

@end
