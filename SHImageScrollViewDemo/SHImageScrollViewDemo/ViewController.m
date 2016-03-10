//
//  ViewController.m
//  轮播图多一张欺骗版
//
//  Created by 宋浩文的pro on 16/2/18.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"
#import "SHImageScrollView.h"


/**
 *  思路是这样的： 在第一张前 加 最后一张图片
 *              在最后一张后 加 第一张图片
 *              然后利用设置偏移来进行视觉欺骗
 */



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SHImageScrollView *imageScrollView = [[SHImageScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 200)];
    imageScrollView.imageArray = @[@"http://pic.58pic.com/58pic/16/38/57/02958PICizD_1024.jpg",@"http://pic38.nipic.com/20140225/12213820_113430471000_2.jpg",@"http://image.tianjimedia.com/uploadImages/2012/004/67U0IYRSH5GP.jpg",@"http://pic34.nipic.com/20131019/12213820_163423919000_2.jpg",@"http://image.tianjimedia.com/uploadImages/2015/013/24/K71I70KFJ9CK_1000x500.jpg"];
    [self.view addSubview:imageScrollView];
    
}


@end
