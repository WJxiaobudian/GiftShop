//
//  XWHomeViewController.m
//  News
//
//  Created by WJ on 16/1/23.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSGiftShopViewController.h"
#import "GSTitleLabel.h"
#import "GSGiftShopController.h"

/* 小的滚动菜单栏的高度 */
#define ScrollerWidth 40
@interface GSGiftShopViewController ()<UIScrollViewDelegate>

/* 大的滑动视图 */
@property (nonatomic, strong) UIScrollView *bigScrollView;

/* 小的滑动视图 */
@property (nonatomic, strong) UIScrollView *smallScrollView;

/* 小的滑动视图上的小标题 */
@property (nonatomic, strong) NSArray *arrayList;

@end


@implementation GSGiftShopViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /* 添加滑动视图 */
    [self setScrollerView];
}

/* 懒加载 */
- (NSArray *)arrayList {
    if (_arrayList == nil) {
        _arrayList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GiftShop" ofType:@"plist"]];
    }
    return _arrayList;
}

/* 添加滑动视图 */
- (void)setScrollerView {
    
    /* 是否开启自动调整视图 默认为YES */
    self.automaticallyAdjustsScrollViewInsets = NO;
    
#pragma mark  ----- 添加视图
#pragma mark 添加小的滚动菜单栏
    /* 添加小的滚动菜单栏 */
    /* 64 是上面NavigationController 的高度 */
    UIScrollView * smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScrollerWidth)];
    
    /* 小的菜单栏的颜色 */
        smallScrollView.backgroundColor = [UIColor colorWithRed:1.000 green:0.500 blue:0.000 alpha:0.489];
    
    /* 把滚动视图添加到View上 */
    [self.view addSubview:smallScrollView];
    
    /* 横竖的滚动条是否显示 默认是YES */
    smallScrollView.showsHorizontalScrollIndicator = NO;
    smallScrollView.showsVerticalScrollIndicator = NO;
    self.smallScrollView = smallScrollView;
    
#pragma mark  添加大的滚动视图
    /* 添加大的滚动视图 */
    UIScrollView * bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + ScrollerWidth, ScreenWidth, ScreenHeight - 64 - ScrollerWidth)];
    
    /* 大的滚动视图的颜色 */
//    bigScrollView.backgroundColor = [UIColor blueColor];
    
    /* 把大的滚动视图添加到页面上 */
    [self.view addSubview:bigScrollView];
    
    /* 横竖滚动条是否显示 默认YES */
    //    bigScrollView.showsVerticalScrollIndicator = NO;
    bigScrollView.showsHorizontalScrollIndicator = NO;
    bigScrollView.delegate = self;
    self.bigScrollView = bigScrollView;
    
#pragma mark   添加其他控制器
    /* 添加子控制器 */
    [self addChildViewController];
    
    /* 添加标题栏 */
    [self addLabel];
    
    /* 设置大的scrollView的滚动范围 */
    CGFloat contectX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.bigScrollView.contentSize = CGSizeMake(contectX, 0);
    self.bigScrollView.pagingEnabled = YES;
    
    /* 添加默认子控制器(也就是第一个) */
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    GSTitleLabel *label = [self.smallScrollView.subviews firstObject];
    label.scale = 1.0;
    
}

- (void) addChildViewController {
    for (int i=0 ; i<self.arrayList.count ;i++){
        GSGiftShopController *vc = [[GSGiftShopController alloc]init];
        
        vc.title = self.arrayList[i][@"title"];
        vc.urlString = self.arrayList[i][@"urlString"];
        [self addChildViewController:vc];
    }
    
}

#pragma mark ------- 添加标题栏
- (void) addLabel {
    
    /* 设置标签的大小*/
    CGFloat labelWidth = 70;
    CGFloat labelHeight = 40;
    
    /* 第一个标签的坐标 */
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    /* 设置每一个标签的坐标 */
    for (int i = 0; i < self.arrayList.count; i ++) {
        /* 第 i 个标签的 X 值*/
        labelX = i * labelWidth;
        GSTitleLabel *label = [[GSTitleLabel alloc] init];
        
        /* 每一个标签的坐标位置和大小*/
        label.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        
        /* 设置每一个标签的题头名称 */
        UIViewController *viewController = self.childViewControllers[i];
        label.text = viewController.title;
        
        /* 设置标签字体和大小  可以使用系统自带 */
        label.font = [UIFont fontWithName:@"HYQiHei" size:19];
        
        [self.smallScrollView addSubview:label];
        /* 给每一个标签做一个唯一的标识符 */
        label.tag = i;
        
        /* 用于用户交互 默认为NO */
        label.userInteractionEnabled = YES;
        
        /* 添加手势 */
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    
    /* 设置小的滑动视图的滚动范围  横向滚动 */
    self.smallScrollView.contentSize = CGSizeMake(labelWidth * self.arrayList.count, 0);
    
}

#pragma mark ----- 标签栏的点击事件
/* 点击任意一个标签的响应事件  大的滚动视图滚动到指定的位置 */
- (void)labelClick:(UITapGestureRecognizer *)recognizer {
    
    /* 强转成label*/
    GSTitleLabel *titleLabel = (GSTitleLabel *)recognizer.view;
    
    /* 当点击任意一个标签之后 大的滚动视图的X值随之变化 */
    CGFloat offsetX = titleLabel.tag * self.bigScrollView.frame.size.width;
    
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
}

#pragma mark ---------- ScrollView 的代理方法
/* 滚动结束(手势导致) */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/* 滚动结束后调用(代码导致) */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    /* 获得索引 */
    NSInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    
    GSTitleLabel *titleLabel = (GSTitleLabel*)self.smallScrollView.subviews[index];
    
    CGFloat offsetX  = titleLabel.center.x - self.smallScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
    
    if (offsetX < 0) {
        offsetX = 0;
    } else if(offsetX > offsetMax ){
        offsetX = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetX, self.smallScrollView.contentOffset.y);
    [self.smallScrollView setContentOffset:offset animated:YES];
    
    GSGiftShopController *newsTable = self.childViewControllers[index];
    newsTable.index = index;
    
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != index) {
            GSTitleLabel *temLabel = self.smallScrollView.subviews[idx];
            temLabel.scale = 0.0;
        }
    }];
    if (newsTable.view.superview) {
        return;
    }
    newsTable.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:newsTable.view];
}

/* 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /* 取出绝对值 避免最左边往右拉时形变超过1 */
    CGFloat value = ABS(scrollView.contentOffset.x /scrollView.frame.size.width);
    NSInteger leftIndex = (int)value;
    NSInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    GSTitleLabel *label = self.smallScrollView.subviews[leftIndex];
    label.scale = scaleLeft;
    
    if (rightIndex < self.smallScrollView.subviews.count) {
        GSTitleLabel *labelRight = self.smallScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
    
}
@end
