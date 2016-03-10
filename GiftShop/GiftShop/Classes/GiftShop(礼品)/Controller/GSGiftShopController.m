//
//  GSGiftShopController.m
//  GiftShop
//
//  Created by WJ on 16/2/29.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSGiftShopController.h"
#import "GSSearchController.h"
#import "GSGiftShopCell.h"
#import "GSGiftShop.h"
#import "GSStrategyController.h"
#import "GSScroll.h"
#import "GSFirstModel.h"
#import "GSFirstCell.h"
#import "GSGiftShopScrollController.h"
#import "GSHeader.h"

@interface GSGiftShopController ()<SDCycleScrollViewDelegate, firstCellDelegate>

@property (nonatomic, strong) NSMutableArray *scrollArray;

@property (nonatomic, strong) SDCycleScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *scrollDatas;

@property (nonatomic, strong) NSMutableArray *scrollImage;

@property (nonatomic, strong) NSMutableArray *giftShopArray;

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

/** 全局 tabelview */
static NSString *const giftShopID = @"GiftShop";


static NSString *const firstID = @"first";

@implementation GSGiftShopController

/** 懒加载 第一个分区数据 */
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/** 懒加载 头部轮播图的图片*/
- (NSMutableArray *)scrollImage {
    if (!_scrollImage) {
        _scrollImage = [NSMutableArray array];
    }
    return _scrollImage;
}

/** 懒加载 头部轮播图的详细数据 */
- (NSMutableArray *)scrollDatas {
    if (!_scrollDatas) {
        _scrollDatas = [NSMutableArray array];
    }
    return _scrollDatas;
}

- (NSMutableArray *)scrollArray {
    if (!_scrollArray) {
        _scrollArray = [NSMutableArray array];
    }
    return _scrollArray;
}

- (NSMutableArray *)giftShopArray {
    if (!_giftShopArray) {
        _giftShopArray = [NSMutableArray array];
    }
    return _giftShopArray;
}


- (void)viewDidLoad {
    
    self.view.backgroundColor = XMGGlobalBg;
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"礼品屋";
   
     self.urlString = self.urlString;
    
    /** 基础设置 */
    [self setupNav];
    
    /** 加载tableView 头部视图 轮播图*/
    [self loadHeaderView];
    
    /** 加载第一个分区 ScrollView*/
    [self loadFirstCell];
    
    /** 加载数据 刷新*/
    [self setupRefresh];

}

/** 重新set 方法 拿到数据*/
- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
}

- (void)setupNav {

    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
   
    /** 注册tabelview */
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GSGiftShopCell class]) bundle:nil] forCellReuseIdentifier:giftShopID];
    
    
}

#pragma mark  ---- tableview 头部视图 轮播图
- (void)loadHeaderView {
    
    /**
     *   判断当前的视图是否是自己想要在页面上加载的
     */
    if (![self.urlString isEqualToString:@"100"]) {
        return;
    }
    
    /** 设置头部轮播图的位置 代理 和 占位图片*/
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150) delegate:self placeholderImage:[UIImage imageNamed:@"234.png"]];
    
    /** 轮播图上page的颜色 */
    self.scrollView.currentPageDotColor = [UIColor whiteColor];
    
    /** 把当前轮播图添加到tableView 的头视图上 */
    self.tableView.tableHeaderView = self.scrollView;
    
    /** 加载数据 */
    [[AFHTTPSessionManager manager] GET:@"http://api.liwushuo.com/v2/banners?channel=iOS" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *data = responseObject[@"data"];
        for (NSDictionary *dict in data[@"banners"]) {
            GSScroll *scroll = [[GSScroll alloc] initWithDict:dict];
            
            if (scroll.target == nil) {
                continue ;
            }
            [self.scrollArray addObject:scroll];
            [self.scrollDatas addObject:data];
            [self.scrollImage addObject:scroll.image_url];
            
        }
        
        /** 轮播图上圆点位置居中显示*/
        self.scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        
        /** 轮播图上显示的图片数据 */
        self.scrollView.imageURLStringsGroup = self.scrollImage;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



#pragma  mark ---- 第一个分区 scrollView
- (void)loadFirstCell {
    
    /**
     *  判断当前的视图是否是自己想要在页面上加载的
     */
    
    if (![self.urlString isEqualToString:@"100"]) {
        return;
    }
    
    /** 解析数据 */
    [[AFHTTPSessionManager manager] GET:@"http://api.liwushuo.com/v2/secondary_banners?gender=1&generation=0" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSArray *array = dict[@"secondary_banners"];
        for (NSDictionary *dictImage in array) {

            GSFirstModel *model = [[GSFirstModel alloc] initWithDict:dictImage];
            [self.dataArray addObject:model];
        
         }
        /**
         *  根据当前的item 和section 获得NSIdexPath， 根据NSIndexPath 刷新当前数据
         */
        NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma  mark ---- 加载tabelview 数据
- (void)setupRefresh {
    
    /** 下拉刷新数据 */
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewGift)];

    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    /** 第一次进入当前页面 自动刷新数据 */
    [self.tableView.mj_header beginRefreshing];

    /** 上拉加载更多数据 */
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGift)];

}

#pragma mark ---- 下拉刷新数据
- (void)loadNewGift {
    
    /** 指示器*/
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    /** 停止上拉加载 */
    [self.tableView.mj_footer endRefreshing];
    self.offset = 0;
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/channels/%@/items?gender=1&generation=1&limit=20", self.urlString];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"offset"] = @(self.offset);
    
    [[AFHTTPSessionManager manager] GET:string parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        /** 清空当前数组中的所有数据 */
        [self.giftShopArray removeAllObjects];
        
        NSDictionary *array = responseObject[@"data"];
        [SVProgressHUD dismiss];
        for (NSDictionary *dict in array[@"items"]) {
            GSGiftShop *giftShop = [[GSGiftShop alloc] initWithDict:dict];
 
            [self.giftShopArray addObject:giftShop];
        }

        /** 判断当前数组是否为空 */
        if (self.giftShopArray != nil && ![self.giftShopArray isKindOfClass:[NSNull class]] && self.giftShopArray.count != 0) {
            
            /** 刷新界面 并停止下拉刷新*/
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        /** 如果刷新失败 */
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ----- 上拉加载更多的数据
- (void)loadMoreGift {
    
    [self.tableView.mj_header endRefreshing];
    self.offset += 20;
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/channels/%@/items?gender=1&generation=1&limit=20", self.urlString];
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    diction[@"offset"] = @(self.offset);
    [[AFHTTPSessionManager manager] GET:string parameters:diction success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *array = responseObject[@"data"];
        for (NSDictionary *dict in array[@"items"]) {
            
            GSGiftShop *giftShop = [[GSGiftShop alloc] initWithDict:dict];
            [self.giftShopArray addObject:giftShop];
        }

        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.offset -= 20;
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /** 如果数组为空则隐藏上拉加载， 不为空则显示 */
    self.tableView.mj_footer.hidden = (self.giftShopArray.count == 0);

        if (section == 0) {
            if (![self.urlString isEqualToString:@"100"]) {
                return 0;
            }
            return 1;
        } else {
            return self.giftShopArray.count;
        }
}

/** tabelView header height */
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    } else {
        return 5;
    }
}

/** 多少分区 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return    2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        GSFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:firstID];
        
        /**
         *  tabelviewCell 的重用
         */
        if (cell == nil) {
            cell = [[GSFirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:firstID];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.data = self.dataArray;
        cell.delegate = self;
        return cell;
        
    } else {
    
        GSGiftShopCell *cell = [tableView dequeueReusableCellWithIdentifier:giftShopID];
  
        cell.giftShop = self.giftShopArray[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    }
    return 180;
}

/** tabelviewcell 的点击事件*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GSStrategyController *strategy = [[GSStrategyController alloc] init];
    
    GSGiftShop *gift = self.giftShopArray[indexPath.row];
    
    strategy.cover_webp_url = gift.cover_webp_url;
    strategy.titleLabel = gift.title;
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/posts/%@",gift.NumString];
    strategy.urlString = string;
    
    [self.navigationController pushViewController:strategy animated:YES];
}


#pragma mark ---- tableView的第一个分区的点击事件
- (void)firstCellClick:(UIButton *)sender {
    GSGiftShopScrollController *scroll = [[GSGiftShopScrollController alloc] init];
    GSStrategyController *strategy = [[GSStrategyController alloc] init];
    GSFirstModel *model = self.dataArray[sender.tag];
    if ([[[model.target_url componentsSeparatedByString:@"="] lastObject] isEqualToString:@"navigation"]) {
        
        NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/posts/%@",model.urlString];
        strategy.urlString = string;

        [[AFHTTPSessionManager manager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dict= responseObject[@"data"];
            strategy.cover_webp_url = dict[@"cover_webp_url"];
            strategy.title = dict[@"title"];

//            [strategy setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:strategy animated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else {
        
        scroll.url = model.url;
        [scroll setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:scroll animated:YES];
    }

   

}

#pragma mark ----- 头部轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    GSGiftShopScrollController *scrollView = [[GSGiftShopScrollController alloc] init];
    GSScroll *scroll = self.scrollArray[index];
    scrollView.url = scroll.target_id;
    scrollView.title = scroll.title;
    scrollView.nameTitle = scroll.title;
   
    [self.navigationController pushViewController:scrollView animated:YES];
    
}

/**
 *  当内存警告时调用的方法
 */
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
