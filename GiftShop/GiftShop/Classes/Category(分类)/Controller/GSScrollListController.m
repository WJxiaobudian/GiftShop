//
//  GSScrollViewController.m
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSScrollListController.h"
#import "GSGiftShop.h"
#import "GSScrollViewCell.h"
#import "GSGiftShopScrollController.h"

@interface GSScrollListController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, strong) UITableView *tableView;
@end

static NSString *const giftShopID = @"GSScrollViewCell";

@implementation GSScrollListController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = XMGGlobalBg;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.title = @"全部专题";

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GSScrollViewCell class]) bundle:nil] forCellReuseIdentifier:giftShopID];

    
    [self setupRefresh];
}

- (void)setupRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

- (void)loadNewData {
    [self.tableView.mj_footer endRefreshing];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    self.offset = 0;
    dict[@"offset"] = @(self.offset);
    [[AFHTTPSessionManager manager] GET:@"http://api.liwushuo.com/v2/collections?limit=20" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.dataArray removeAllObjects];
        
        NSDictionary *dict = responseObject[@"data"];
        NSArray *array = dict[@"collections"];
        for (NSDictionary *dic in array) {
            GSGiftShop *gift = [[GSGiftShop alloc] initWithDict:dic];
            
            [self.dataArray addObject:gift];
            
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreData {
    
    [self.tableView.mj_header endRefreshing];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    self.offset += 20;
    dict[@"offset"] = @(self.offset);
    [[AFHTTPSessionManager manager] GET:@"http://api.liwushuo.com/v2/collections?limit=20" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSArray *array = dict[@"collections"];
        for (NSDictionary *dic in array) {
            GSGiftShop *gift = [[GSGiftShop alloc] initWithDict:dic];
            
            [self.dataArray addObject:gift];
            
            [self.tableView reloadData];
        }
        
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSScrollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:giftShopID forIndexPath:indexPath];

    if (self.dataArray != nil && ![self.dataArray isEqual:[NSNull class]] && self.dataArray.count != 0) {
        
        GSGiftShop *shop = self.dataArray[indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.giftShop = shop;
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSGiftShopScrollController *strategy = [[GSGiftShopScrollController alloc] init];
    GSGiftShop *shop = self.dataArray[indexPath.row];
    
    strategy.url = shop.userId;
    
    strategy.nameTitle = shop.title;
    [self.navigationController pushViewController:strategy animated:YES];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。注意跟ios6.0之前的区分
    // Add code to clean up any of your own resources that are no longer necessary.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    
        }
    }
    
   
}
@end
