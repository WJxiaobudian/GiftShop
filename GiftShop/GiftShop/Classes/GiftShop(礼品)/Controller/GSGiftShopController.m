//
//  GSGiftShopController.m
//  GiftShop
//
//  Created by WJ on 16/2/29.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSGiftShopController.h"
#import "GSSearchController.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "GSGiftShopCell.h"
#import "GSGiftShop.h"
#import "GSStrategyController.h"
@interface GSGiftShopController ()

@property (nonatomic, strong) NSMutableArray *giftShopArray;

@property (nonatomic, assign) int offset;

@property (nonatomic, strong) NSMutableDictionary *dict;

@end

static NSString *const giftShopID = @"GiftShop";
@implementation GSGiftShopController


- (NSMutableArray *)giftShopArray {
    if (!_giftShopArray) {
        _giftShopArray = [NSMutableArray array];
    }
    return _giftShopArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupNav];
    self.urlString = self.urlString;
    
    [self setupRefresh];
    
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
}


- (void)setupNav {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"204"] style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GSGiftShopCell class]) bundle:nil] forCellReuseIdentifier:giftShopID];
    
}

- (void)rightClick {
    
}
- (void)setupRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewGift)];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGift)];

}

- (void)loadNewGift {
    
    [self.tableView.mj_footer endRefreshing];
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/channels/%@/items?gender=1&generation=1&limit=20&offset=0", self.urlString];
    
    [self.giftShopArray removeAllObjects];
    [[AFHTTPSessionManager manager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *array = responseObject[@"data"];
        for (NSDictionary *dict in array[@"items"]) {
//
            
            GSGiftShop *giftShop = [[GSGiftShop alloc] initWithDict:dict];
 
            
            [self.giftShopArray addObject:giftShop];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreGift {
    [self.tableView.mj_header endRefreshing];
    self.offset += 20;
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/channels/%@/items?gender=1&generation=1&limit=20&offset=%d", self.urlString, self.offset];
    
    [[AFHTTPSessionManager manager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *array = responseObject[@"data"];
        for (NSDictionary *dict in array[@"items"]) {
            GSGiftShop *giftShop = [[GSGiftShop alloc] initWithDict:dict];

            [self.giftShopArray addObject:giftShop];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.offset -= 20;
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.giftShopArray.count == 0);
    return self.giftShopArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSGiftShopCell *cell = [tableView dequeueReusableCellWithIdentifier:giftShopID];
    cell.giftShop = self.giftShopArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GSStrategyController *strategy = [[GSStrategyController alloc] init];
    
    GSGiftShop *gift = self.giftShopArray[indexPath.row];
    strategy.urlString = gift.content_url;
    strategy.cover_webp_url = gift.cover_webp_url;
    strategy.title = gift.title;
    [strategy setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:strategy animated:YES];
    
}

@end
