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

@property (nonatomic, strong) NSArray *receiveArray;

@end

@implementation SHImageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _hasTimer = YES;
        _hasPageControl = YES;
        
        [self setTimer];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

#pragma mark - 私有方法
- (void)setScrollView
{
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height)];
    self.imageScrollView.contentSize = CGSizeMake(ScreenWidth * (self.receiveArray.count + 2), self.height);
    self.imageScrollView.delegate = self;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.imageScrollView.pagingEnabled = YES;
    [self addSubview:self.imageScrollView];
    
    
    for (int i = 0; i < self.receiveArray.count + 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, self.height)];
        imageView.userInteractionEnabled = YES;
        if (i == 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.receiveArray.lastObject] placeholderImage:[UIImage imageNamed:_placeHolderImageName]];
            imageView.image = [UIImage imageNamed:self.receiveArray.lastObject];
            [self.imageScrollView addSubview:imageView];
            continue;
        } else if (i == self.receiveArray.count + 1) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.receiveArray[0]]];
            imageView.image = [UIImage imageNamed:self.receiveArray[0]];
            [self.imageScrollView addSubview:imageView];
            
        } else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.receiveArray[i - 1]]];
            imageView.image = [UIImage imageNamed:self.receiveArray[i - 1]];
            [self.imageScrollView addSubview:imageView];
        }
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tapGR];
        
    }
    
    // 设置scrollView的偏移为第二张处
    self.imageScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    
    [self setPageControl];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tapGR
{
    NSInteger index = self.imageScrollView.contentOffset.x / ScreenWidth;
    NSLog(@"点击事件： %ld", index);
    if ([self.delegate respondsToSelector:@selector(imageScrollView:didSelectedItem:)]) {
        [self.delegate imageScrollView:self didSelectedItem:index];
    }
    
}

- (void)setPageControl
{
    if (_hasPageControl == NO) return;
    
    
    if (_pageControl) [_pageControl removeFromSuperview];
    
    self.pageControl = [[UIPageControl alloc] init];
    
    if (CGRectEqualToRect(_pageControlFrame, CGRectZero)) {
        _pageControlFrame = CGRectMake(0, self.height * 0.7, ScreenWidth, 20);
    }
    self.pageControl.frame = _pageControlFrame;
    self.pageControl.numberOfPages = self.receiveArray.count;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = _pageTintColor;
    self.pageControl.currentPageIndicatorTintColor = _pageCurrentColor;
    [self addSubview:self.pageControl];
}

- (void)setTimer
{
    if (_hasTimer == NO) return;
    
    // 默认为两秒
    if (!_timeSpace) {
        _timeSpace = 2;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeSpace target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)timerAction
{
    // 拿到当前的偏移量，向前移动一个屏幕宽度
    CGFloat currentOffsetX = self.imageScrollView.contentOffset.x;
    CGFloat moveOffsetX = currentOffsetX + ScreenWidth;
    [self.imageScrollView setContentOffset:CGPointMake(moveOffsetX, 0) animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger x = scrollView.contentOffset.x / ScreenWidth;
    // 如果移动到了最后一张， 自动瞬移到第一张（偏移量为第二）
    if (x == self.receiveArray.count + 1) {
        
        [scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
        [self.pageControl setCurrentPage:0];
        
    }else if (scrollView.contentOffset.x <= 0) {  // 这里就不用x判断了，因为x为整数，正好卡在那一点的话，移动的非常快会出现滑不过去的现象
        
        // 如果移动到了第一张， 自动瞬移到倒数第一张(偏移量为倒数第二)
        [scrollView setContentOffset:CGPointMake(ScreenWidth * self.receiveArray.count, 0) animated:NO];
        [self.pageControl setCurrentPage:self.receiveArray.count - 1];
        
    } else {
        
        [self.pageControl setCurrentPage:x - 1];
        
    }
}


- (void)oneImage:(NSString *)imageName
{
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height)];
    self.imageScrollView.contentSize = CGSizeMake(ScreenWidth, self.height);
    self.imageScrollView.delegate = self;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.imageScrollView.pagingEnabled = YES;
    [self addSubview:self.imageScrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.imageScrollView.bounds];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:_placeHolderImageName]];
    imageView.image = [UIImage imageNamed:imageName];
    [self.imageScrollView addSubview:imageView];
    
    // 一张就别滚动了
    [self.timer invalidate];
}

#pragma mark - 属性setter方法
- (void)setImageArrayFromNet:(NSArray *)imageArrayFromNet
{
    _imageArrayFromNet = imageArrayFromNet;
    self.receiveArray = imageArrayFromNet;
    
    // 处理图片只有一张的情况,不需要timer,不需要pageControl
    if (self.receiveArray.count == 1) {
        NSString *imageUrlString = self.receiveArray.firstObject;
        [self oneImage:imageUrlString];
        return;
    }
    
    [self setScrollView];
}

- (void)setImageArrayFromLocal:(NSArray *)imageArrayFromLocal
{
    _imageArrayFromLocal = imageArrayFromLocal;
    self.receiveArray = imageArrayFromLocal;
    
    // 处理图片只有一张的情况,不需要timer,不需要pageControl
    if (self.receiveArray.count == 1) {
        NSString *imageUrlString = self.receiveArray.firstObject;
        [self oneImage:imageUrlString];
        return;
    }
    
    [self setScrollView];
}

- (void)setHasTimer:(BOOL)hasTimer
{
    _hasTimer = hasTimer;
    
    // 来到了这，如果timer还没实例化，_hasTimer可以把它挡在外面
    // 如果来到这已经实例化了，invalidate可以起作用
    if (hasTimer == NO) {
        [self.timer invalidate];
    }
}

- (void)setHasPageControl:(BOOL)hasPageControl
{
    _hasPageControl = hasPageControl;
    
    if (hasPageControl == NO) {
        [self.pageControl removeFromSuperview];
    }
    
}

- (void)setPlaceHolderImageName:(NSString *)placeHolderImageName
{
    _placeHolderImageName = placeHolderImageName;
}

- (void)setPageControlFrame:(CGRect)pageControlFrame
{
    _pageControlFrame = pageControlFrame;
    
    [self setPageControl];
}

- (void)setPageCurrentColor:(UIColor *)pageCurrentColor
{
    _pageCurrentColor = pageCurrentColor;
    
    [self setPageControl];
}

- (void)setPageTintColor:(UIColor *)pageTintColor
{
    _pageTintColor = pageTintColor;
    
    [self setPageControl];
}

- (NSArray *)receiveArray
{
    if (_receiveArray == nil) {
        _receiveArray = [NSArray array];
    }
    return _receiveArray;
}

- (void)dealloc
{
    NSLog(@"轮播图销毁了");
}

@end
