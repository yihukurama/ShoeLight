//
//  AdScrollView.m
//
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
// 


#import "AdScrollView.h"
#import "UIImageView+WebCache.h"
#import "Advertisement.h"
#import "macro.h"
#import "UIView+Frame.h"
#import "NSTimer+Add.h"
#import "UIImage+Strech.h"


/** 自动切换图片的时间（秒） */
#define kSwitchImageTime 7


@interface AdScrollView ()

{
    //循环滚动的周期时间
    NSTimer * _autoPlayTimer;
    UIPageControl *_pageControl;
    // 当前显示的广告序号
    NSUInteger _currentAdIndex;
}

//循环滚动的三个视图
@property (strong,nonatomic) UIImageView * leftImageView;
@property (strong,nonatomic) UIImageView * centerImageView;
@property (strong,nonatomic) UIImageView * rightImageView;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation AdScrollView

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupScrollView];
        [self setupImageViews];
        [self setupPageControl];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupScrollView];
    [self setupImageViews];
    [self setupPageControl];
}

#pragma mark - 创建UI
- (void)setupImageViews
{
    _leftImageView = [[UIImageView alloc]init];
    _centerImageView = [[UIImageView alloc]init];
    _rightImageView = [[UIImageView alloc]init];
    [self.scrollView addSubview:_leftImageView];
    [self.scrollView addSubview:_centerImageView];
    [self.scrollView addSubview:_rightImageView];
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    UITapGestureRecognizer *centerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    
    [_leftImageView addGestureRecognizer:leftTap];
    [_centerImageView addGestureRecognizer:centerTap];
    [_rightImageView addGestureRecognizer:rightTap];
    
    _leftImageView.userInteractionEnabled = YES;
    _centerImageView.userInteractionEnabled = YES;
    _rightImageView.userInteractionEnabled = YES;
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.bounces = NO;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

- (void)setupPageControl
{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.pageIndicatorTintColor = kDarkGrayColor;
    _pageControl.currentPageIndicatorTintColor = kWhiteColor;
    
//    UIImage *currentPageImage = [[UIImage alloc]initWithSize:CGSizeMake(10, 5) color:kOrangeColor];
//    [_pageControl setValue:currentPageImage forKey:@"currentPageImage"];
//    
//    UIImage *pageImage = [[UIImage alloc]initWithSize:CGSizeMake(10, 5) color:kLightGrayColor];
//    [_pageControl setValue:pageImage forKey:@"pageImage"];

    [self addSubview:_pageControl];
}

#pragma mark - Getter
- (UIPageControl *)pageControl
{
    return _pageControl;
}

#pragma mark - Overide
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // ImageViews
    CGFloat imageViewW = self.width;
    CGFloat imageViewH = self.height;
    _leftImageView.frame = CGRectMake(0, 0, imageViewW, imageViewH);
    _centerImageView.frame = CGRectMake(imageViewW, 0, imageViewW, imageViewH);
    _rightImageView.frame = CGRectMake(imageViewW * 2, 0, imageViewW, imageViewH);
    
    // PageControl
    if (self.pageControlShowStyle != UIPageControlShowStyleNone && self.advertisements.count > 1) {
        
        _pageControl.hidden = NO;
        _pageControl.numberOfPages = self.advertisements.count;
        _pageControl.currentPage = _currentAdIndex;
        
        CGFloat pageControlY = self.height - 20;
        CGFloat pageControlW = 20 * _pageControl.numberOfPages;
        CGFloat pageControlH = 20;
        _pageControl.frame = CGRectMake(0, pageControlY, pageControlW, pageControlH);
        
        switch (self.pageControlShowStyle) {
            case UIPageControlShowStyleLeft:
                _pageControl.x = 10;
                break;
            case UIPageControlShowStyleCenter:
                _pageControl.center = CGPointMake(self.height - 10 , self.width * 0.5);
                break;
            case UIPageControlShowStyleRight:
                _pageControl.x = self.width - pageControlW;
                break;
            default:
                break;
        }
        
    } else {
        _pageControl.hidden = YES;
    }
    
    // ScrollView
    self.scrollView.frame = CGRectMake(0, 0, self.width, self.height);
    self.scrollView.contentOffset = CGPointMake(self.width, 0);
    self.scrollView.contentSize = CGSizeMake(self.width * 3, self.height);
    self.scrollView.scrollEnabled = self.advertisements.count > 1;
}

#pragma mark - Action
- (void)tapImageView:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    
    if([self.delegate respondsToSelector:@selector(adScrollView:didTapImageView:advertisement:)]) {
        Advertisement *ad = self.advertisements[imageView.tag];
        [self.delegate adScrollView:self didTapImageView:imageView advertisement:ad];
    }
}

#pragma mark - Setter
- (void)setAdvertisements:(NSArray *)advertisements
{
    if (_autoPlayTimer) {
        [_autoPlayTimer invalidate];
    }
    
    _advertisements = advertisements;
    
    // 进来默认显示第1张图片（0即是第1张）
    _currentAdIndex = 0;
    
    [self setImageView:_leftImageView withAdIndex:[self adIndexWithNum:-1]];
    [self setImageView:_centerImageView withAdIndex:[self adIndexWithNum:0]];
    [self setImageView:_rightImageView withAdIndex:[self adIndexWithNum:1]];
    [self setNeedsLayout];

    // scrollView滚动到中间
    [self.scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
    
    // 自动轮播
    if (advertisements.count > 1) {
        _autoPlayTimer = [NSTimer scheduledTimerWithTimeInterval:kSwitchImageTime target:self selector:@selector(switchImage) userInfo:nil repeats:YES];
    }
}

- (void)setPageControlShowStyle:(UIPageControlShowStyle)pageControlShowStyle
{
    _pageControlShowStyle = pageControlShowStyle;
    [self setNeedsLayout];
}

#pragma mark - Private
/**
 *  自动轮播图片
 */
- (void)switchImage
{
    if (self.advertisements.count < 2) {
        return;
    }
    
    // 只有2张以上才切换，1张时不切换
    [self.scrollView setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

/**
 *  根据一个序号计算处于图片的序号
 *
 *  @param num 序号
 */
- (NSInteger)adIndexWithNum:(NSInteger)num
{
    if (self.advertisements.count == 0) {
        return 0;
    } else {
        return (num + self.advertisements.count) % self.advertisements.count;
    }
}

/**
 *  把第 adIndex + 1 张图片显示到ImageView中
 *
 *  @param imageView UIimageView
 *  @param adIndex   广告的序号
 */
- (void)setImageView:(UIImageView *)imageView withAdIndex:(NSInteger)adIndex
{
    if (_advertisements.count == 0) {
        return;
    }
    
    Advertisement *ad = _advertisements[adIndex];
    NSString *imageUrlStr = ad.imageUrl;
    imageView.tag = adIndex;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:nil];
}

#pragma mark - UIScrollView代理
// 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_advertisements.count == 0) {
        return;
    }
    
    // 获取当前显示图片的序号
    if (self.scrollView.contentOffset.x == 0){
        // 左滑
        _currentAdIndex = [self adIndexWithNum:_currentAdIndex - 1];
        _pageControl.currentPage = _currentAdIndex;
        
    } else if(self.scrollView.contentOffset.x == self.width * 2) {
        // 右滑
       _currentAdIndex = [self adIndexWithNum:_currentAdIndex + 1];
       _pageControl.currentPage = _currentAdIndex;
        
    } else {
        // 没动
        return;
    }
    
    // 重新设置广告显示
    NSInteger leftAdIndex = [self adIndexWithNum:_currentAdIndex - 1];
    [self setImageView:_leftImageView withAdIndex:leftAdIndex];
    
    NSInteger centerAdIndex = [self adIndexWithNum:_currentAdIndex];
    [self setImageView:_centerImageView withAdIndex:centerAdIndex];
    
    NSInteger rightAdIndex = [self adIndexWithNum:_currentAdIndex + 1];
    [self setImageView:_rightImageView withAdIndex:rightAdIndex];
    
//    NSLog(@"AdScrollView:%p \n currentIndex:%d \n leftAdIndex:%d ----- centerAdIndex:%d ----- rightAdIndex:%d",self.scrollView,_currentAdIndex,leftAdIndex,centerAdIndex,rightAdIndex);
    
    self.scrollView.contentOffset = CGPointMake(self.width, 0);

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    MyLog(@"开始拖动  AdScrollView:%p, currentIndex:%d",scrollView,_currentAdIndex);
    [_autoPlayTimer pause];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    MyLog(@"停止拖动");
    [_autoPlayTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kSwitchImageTime]];
}
@end

