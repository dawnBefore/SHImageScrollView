//
//  ImageScrollView.m
//  轮播图多一张欺骗版
//
//  Created by 宋浩文的pro on 16/2/18.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import "SHImageScrollView.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

/**
 *  思路是这样的： 在第一张前 加 最后一张图片
 *              在最后一张后 加 第一张图片
 *              然后利用设置偏移来进行视觉欺骗来进行位移
 */

@interface SHImageScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *imageScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSUInteger timerIndex;

@end

@implementation SHImageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setScrollView
{
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height)];
    self.imageScrollView.contentSize = CGSizeMake(ScreenWidth * (self.imageArray.count + 2), self.height);
    self.imageScrollView.delegate = self;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.imageScrollView.pagingEnabled = YES;
    [self addSubview:self.imageScrollView];
    
    
    for (int i = 0; i < self.imageArray.count + 2; i++) {
        
        
        if (i == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray.lastObject]];
            [self.imageScrollView addSubview:imageView];
            continue;
        } else if (i == self.imageArray.count + 1) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, self.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[0]]];
            [self.imageScrollView addSubview:imageView];
            
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, self.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i - 1]]];
            [self.imageScrollView addSubview:imageView];
        }
        
    }
    
    // 设置scrollView的偏移为第二张处
    self.imageScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    
    
}

- (void)setPageControl
{
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.bounds = CGRectMake(0, 0, ScreenWidth, 20);
    self.pageControl.numberOfPages = self.imageArray.count;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    self.pageControl.center = CGPointMake(self.imageScrollView.center.x, self.imageScrollView.center.y + 70);
}

- (void)setTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}

- (void)timerAction
{
    _timerIndex++;
    if (_timerIndex == (self.imageArray.count + 1)) {
        _timerIndex = 1;
    }
    
    // 如果移动到了最后一张， 自动瞬移到第一张（偏移量为第二）
    if (self.imageScrollView.contentOffset.x == ScreenWidth * (self.imageArray.count + 1)) {
        
        [self.imageScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
        
    }else if (self.imageScrollView.contentOffset.x == 0) {
        // 如果移动到了第一张， 自动瞬移到倒数第一张(偏移量为倒数第二)
        
        [self.imageScrollView setContentOffset:CGPointMake(ScreenWidth * self.imageArray.count, 0) animated:NO];
    }
    
    [self.imageScrollView setContentOffset:CGPointMake((_timerIndex + 1) * ScreenWidth, 0) animated:YES];
    
    // 调整pageControl
    if (_timerIndex == self.imageArray.count) {
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = _timerIndex;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 如果移动到了最后一张， 自动瞬移到第一张（偏移量为第二）
    if (scrollView.contentOffset.x == ScreenWidth * (self.imageArray.count + 1)) {
        
        [scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
        
    }else if (scrollView.contentOffset.x == 0) {
        
        // 如果移动到了第一张， 自动瞬移到倒数第一张(偏移量为倒数第二)
        [scrollView setContentOffset:CGPointMake(ScreenWidth * self.imageArray.count, 0) animated:NO];
        
    }
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    
    [self setScrollView];
    
    [self setPageControl];
    
    [self setTimer];
}

@end
