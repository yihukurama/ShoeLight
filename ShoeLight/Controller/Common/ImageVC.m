
//
//  ImageVC.m
//  ShoeLight
//
//  Created by even on 16/3/23.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "ImageVC.h"
#import "macro.h"

@interface ImageVC ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    CGRect frame = self.view.frame;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
    [self.view addSubview:self.scrollView];
    
    
    self.imageView = [[UIImageView alloc]init];
    NSString *name = kMyProfileTool.isEnglish ? self.englishImageName : self.chineseImageName;
    UIImage *image = [UIImage imageNamed:name];
    self.imageView.image = image;
    CGFloat imageViewHeight = image.size.height * kScreenWidth / image.size.width;
    frame.size.height = imageViewHeight;
    frame.origin.y = -64;
    self.imageView.frame = frame;
    [self.scrollView addSubview:self.imageView];
    
    self.scrollView.contentSize = frame.size;
    
}



@end
