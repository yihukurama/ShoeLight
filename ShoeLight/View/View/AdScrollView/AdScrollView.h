//
//  AdScrollView.h
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//  循环广告滚动条

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};


@class AdScrollView;
@class Advertisement;

@protocol AdScrollViewDelegate <NSObject>

- (void)adScrollView:(AdScrollView *)adScrollView didTapImageView:(UIImageView *)imageView advertisement:(Advertisement *)advertisement;

@end


@interface AdScrollView : UIView<UIScrollViewDelegate>

@property (strong,nonatomic,readonly) UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *advertisements;
@property (assign,nonatomic) UIPageControlShowStyle pageControlShowStyle;
@property (weak, nonatomic) id <AdScrollViewDelegate> delegate;

@end


