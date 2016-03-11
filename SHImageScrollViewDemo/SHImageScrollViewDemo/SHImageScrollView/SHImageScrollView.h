//
//  SHImageScrollView.h
//  SHImageScrollViewDemo
//
//  Created by 宋浩文的pro on 16/3/10.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHImageScrollView;

@protocol  SHImageScrollViewDelegate <NSObject>

/** 点击了图片，index为第几张图片 */
- (void)imageScrollView:(SHImageScrollView *)imageScrollView didSelectedItem:(NSInteger)index;

@end

/** 屏幕的宽度 */
#define ScreenWidth   [[UIScreen mainScreen] bounds].size.width
/** 屏幕的高度 */
#define ScreenHeigth    [[UIScreen mainScreen] bounds].size.height

@interface SHImageScrollView : UIView

/** 本地图片数组 */
@property (nonatomic, strong) NSArray *imageArrayFromLocal;

/** 网络地址数组 */
@property (nonatomic, strong) NSArray *imageArrayFromNet;

/** 是否有定时器, 默认是有的 */
@property (nonatomic, assign) BOOL hasTimer;

/** 轮播的时间间隔, 默认是两秒 */
@property (nonatomic, assign) CGFloat timeSpace;

/** 是否显示pageControl, 默认显示 */
@property (nonatomic, assign) BOOL hasPageControl;

/** 占位图的名称,默认没有占位图 */
@property (nonatomic, copy) NSString *placeHolderImageName;

/** pageControl的位置 */
@property (nonatomic, assign) CGRect pageControlFrame;

/** 选中的pageControl的颜色 */
@property (nonatomic, strong) UIColor *pageCurrentColor;

/** 没选中的pageControl的颜色 */
@property (nonatomic, strong) UIColor *pageTintColor;

@property (nonatomic, assign) id<SHImageScrollViewDelegate> delegate;

@end
