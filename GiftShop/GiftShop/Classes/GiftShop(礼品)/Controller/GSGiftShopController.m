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
#import "SDCycleScrollView.h"
#import "GSScroll.h"
#import "GSFirstModel.h"
#import "GSFirstCell.h"
#import "GSGiftShopScrollController.h"
@interface GSGiftShopController ()<SDCycleScrollViewDelegate, firstCellDelegate>

@property (nonatomic, strong) NSMutableArray *scrollArray;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *scrollDatas;
@property (nonatomic, strong) NSMutableArray *scrollImage;

@property (nonatomic, strong) NSMutableArray *giftShopArray;

@property (nonatomic, assign) int offset;

@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

static NSString *const giftShopID = @"GiftShop";

static NSString *const firstID = @"first";
@implementation GSGiftShopController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)scrollImage {
    if (!_scrollImage) {
        _scrollImage = [NSMutableArray array];
    }
    return _scrollImage;
}

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
    [super viewDidLoad];
 
     self.urlString = self.urlString;
    
    
    [self setupNav];
    
    [self loadHeaderView];
    
    [self loadFirstCell];
    
    [self setupRefresh];
    
}


- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
}

- (void)setupNav {
    
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GSGiftShopCell class]) bundle:nil] forCellReuseIdentifier:giftShopID];
    
}

- (void)loadFirstCell {
    if (![self.urlString isEqualToString:@"100"]) {
        return;
    }
    [[AFHTTPSessionManager manager] GET:@"http://api.liwushuo.com/v2/secondary_banners?gender=1&generation=1" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSArray *array = dict[@"secondary_banners"];
        for (NSDictionary *dictImage in array) {

            GSFirstModel *model = [[GSFirstModel alloc] initWithDict:dictImage];
            [self.dataArray addObject:model];
            NSLog(@"%@",model.urlString);
         }
        NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)loadHeaderView {
    
    if (![self.urlString isEqualToString:@"100"]) {
        return;
    }
    
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150) delegate:self placeholderImage:[UIImage imageNamed:@"Image_column_default"]];
   
    self.scrollView.currentPageDotColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = self.scrollView;
 
    [[AFHTTPSessionManager manager] GET:@"http://api.liwushuo.com/v2/banners?channel=iOS" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *data = responseObject[@"data"];
        for (NSDictionary *dict in data[@"banners"]) {
            GSScroll *scroll = [[GSScroll alloc] initWithDict:dict];
            [self.scrollArray addObject:scroll];
            [self.scrollDatas addObject:data];
            [self.scrollImage addObject:scroll.image_url];
        }
        self.scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.scrollView.imageURLStringsGroup = self.scrollImage;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (section == 0) {
            if (![self.urlString isEqualToString:@"100"]) {
                return 0;
            }
            return 1;
        } else {
            self.tableView.mj_footer.hidden = (self.giftShopArray.count == 0);
            return self.giftShopArray.count;
            
        }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.giftShopArray.count + 1 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        GSFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:firstID];
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

- (void)firstCellClick:(UIButton *)sender {
    GSGiftShopScrollController *scroll = [[GSGiftShopScrollController alloc] init];
    GSStrategyController *strategy = [[GSStrategyController alloc] init];
    GSFirstModel *model = self.dataArray[sender.tag];
    switch (sender.tag) {
        case 2:
        {
            NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/posts/%@",model.urlString];
            [[AFHTTPSessionManager manager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary *dict= responseObject[@"data"];
                NSLog(@"%@",dict);
                strategy.cover_webp_url = dict[@"cover_image_url"];
                strategy.title = dict[@"title"];
                strategy.urlString = dict[@"content_url"];
                NSLog(@"%@",strategy.cover_webp_url);
                [strategy setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:strategy animated:YES];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
            break;
            
        default:
            scroll.url = model.url;
            [scroll setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:scroll animated:YES];
        
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }
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

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    GSGiftShopScrollController *scrollView = [[GSGiftShopScrollController alloc] init];
    GSScroll *scroll = self.scrollArray[index];
    scrollView.url = scroll.target_id;
    scrollView.title = scroll.title;
    [scrollView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:scrollView animated:YES];
    
}

@end
