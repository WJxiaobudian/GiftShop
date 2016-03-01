//
//  GSGiftShopController.m
//  GiftShop
//
//  Created by WJ on 16/2/29.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSGiftShopController.h"
#import "GSSearchController.h"
#import "GSTitleLabel.h"

/* 小的滚动菜单栏的高度 */
#define ScrollerWidth 40

#define ScreenWidth   [UIScreen mainScreen].bounds.size.width

@interface GSGiftShopController ()

/**
 *  礼品屋scrollView 的借口数组
 */
@property (nonatomic, strong) NSArray *topics;

/**
 *  小的滚动视图
 */
@property (nonatomic, strong) UIScrollView *smallScrollView;


@end

@implementation GSGiftShopController


/** 懒加载*/
- (NSArray *)topics {
    if (!_topics) {
        _topics = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GiftShop" ofType:@"plist"]];
    }
    NSLog(@"%@",_topics);
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"204"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    
    [self setupScrollView];
}


- (void)rightClick {
    
    GSSearchController *search = [[GSSearchController alloc] init];
    
    [self.navigationController pushViewController:search animated:YES];
    
}

- (void)setupScrollView {
    
    // 关闭自动调整视图， 默认为YES
    self.automaticallyAdjustsScrollViewInsets = NO;
    
#pragma mark --- 添加视图
    UIScrollView *smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScrollerWidth)];
    
    
    [self.view addSubview:smallScrollView];
    
    smallScrollView.showsHorizontalScrollIndicator = NO;
    smallScrollView.showsVerticalScrollIndicator = NO;
    
    self.smallScrollView = smallScrollView;

    
    [self addLabel];
    
    GSTitleLabel *titleLabel = [self.smallScrollView.subviews firstObject];
    titleLabel.scale = 1.0;
    
}

- (void)addLabel {
    
    CGFloat labelWidth = 70;
    CGFloat labelHeight = 40;
    
    /* 第一个标签的坐标 */
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    /* 设置每一个标签的坐标 */
    for (int i = 0; i < self.topics.count; i ++) {
        labelX = i * labelWidth;
        
        GSTitleLabel *label = [[GSTitleLabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        
        label.text = self.topics[i][@"title"];
        
        label.font = [UIFont systemFontOfSize:19];
        
        [self.smallScrollView addSubview:label];
        
        label.tag = i;
        
        label.userInteractionEnabled = YES;
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    self.smallScrollView.contentSize = CGSizeMake(self.topics.count * labelWidth, 0);
}

- (void)labelClick:(UIGestureRecognizer *)recognizer {
    
    GSTitleLabel *titleLabel = (GSTitleLabel *)recognizer.view;
    
    CGFloat offset;
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

@end
