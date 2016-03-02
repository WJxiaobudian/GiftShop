//
//  GSGiftShopScrollController.m
//  GiftShop
//
//  Created by WJ on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSGiftShopScrollController.h"
#import "AFNetworking.h"
#import "GSGiftShop.h"
#import "GSGiftShopCell.h"
#import "GSStrategyController.h"
@interface GSGiftShopScrollController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *const giftShopID = @"GiftShop";
@implementation GSGiftShopScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.url = self.url;
    [self setupRefresh];
    self.dataArray = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GSGiftShopCell class]) bundle:nil] forCellReuseIdentifier:giftShopID];
}

- (void)setupRefresh {
    // 显示指示器
    
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/collections/%@/posts?gender=1&generation=1&limit=20&offset=0", self.url];
    NSLog(@"%@",string);
    [[AFHTTPSessionManager manager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSArray *array = dict[@"posts"];
        for (NSDictionary *dic in array) {
            GSGiftShop *gift = [[GSGiftShop alloc] initWithDict:dic];
            NSLog(@"%@",gift.url);
            [self.dataArray addObject:gift];
            [self.tableView reloadData];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSGiftShopCell *cell = [tableView dequeueReusableCellWithIdentifier:giftShopID];
    
    GSGiftShop *shop = self.dataArray[indexPath.row];
    cell.giftShop = shop;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSStrategyController *strategy = [[GSStrategyController alloc] init];
    GSGiftShop *shop = self.dataArray[indexPath.row];
    strategy.urlString = shop.content_url;
    strategy.cover_webp_url = shop.cover_webp_url;
    strategy.title = shop.title;
    [self.navigationController pushViewController:strategy animated:YES];
}
@end
