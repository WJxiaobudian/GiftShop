//
//  GSHotController.m
//  GiftShop
//
//  Created by WJ on 16/2/29.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSHotController.h"
#import "GSHotCell.h"
#import "GSHotModel.h"
#import "MJRefresh.h"
#import "GSTaoBaoController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

static NSString *identifier = @"item_id";
@interface GSHotController ()<UICollectionViewDataSource, UICollectionViewDelegate>
// 用来保存解析出来的数据
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger offset;


@end

@implementation GSHotController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)loadView {
    [super loadView];
    self.hv = [[GSHotView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.hv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 设置代理
    self.hv.listCollectionView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:0.9];
    self.hv.listCollectionView.delegate = self;
    self.hv.listCollectionView.dataSource = self;
    // 注册item
    [self.hv.listCollectionView registerNib:[UINib nibWithNibName:@"GSHotCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    
    [self addRefresh];

}

- (void)addRefresh {
    
    self.hv.listCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.hv.listCollectionView.mj_header.automaticallyChangeAlpha = YES;
    [self.hv.listCollectionView.mj_header beginRefreshing];
    
    self.hv.listCollectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadNewData {
    
    [self.hv.listCollectionView.mj_footer endRefreshing];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    self.offset = 0;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"offset"] = @(self.offset);
    [[AFHTTPSessionManager manager] GET:@"http://api.liwushuo.com/v2/items?gender=1&generation=1&limit=50" parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        [self.dataArray removeAllObjects];
        NSDictionary *dict = responseObject[@"data"];
        for (NSDictionary *dic in dict[@"items"]) {
            NSMutableDictionary *di = dic[@"data"];
            GSHotModel *model = [[GSHotModel alloc] initWithDict:di];
            
            [self.dataArray addObject:model];
            
            if (![model.cover_image_url hasSuffix:@"jpg-w720"]) {
                [self.dataArray removeObject:model];
            }
        }
        [self.hv.listCollectionView reloadData];
        [self.hv.listCollectionView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"数据加载错误"];
        [self.hv.listCollectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    
    [self.hv.listCollectionView.mj_header endRefreshing];
    self.offset += 50;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"offset"] = @(self.offset);
    [[AFHTTPSessionManager manager] GET:@"http://api.liwushuo.com/v2/items?gender=1&generation=1&limit=50" parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        for (NSDictionary *dic in dict[@"items"]) {
            NSMutableDictionary *di = dic[@"data"];
            GSHotModel *model = [[GSHotModel alloc] initWithDict:di];
            [self.dataArray addObject:model];
        }
        [self.hv.listCollectionView reloadData];
        [self.hv.listCollectionView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.hv.listCollectionView.mj_footer endRefreshing];
    }];
    
}

#pragma mark 实现代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    GSHotModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    GSTaoBaoController *taobao = [[GSTaoBaoController alloc] init];
    GSHotModel *model = self.dataArray[indexPath.row];
    NSString *string = [[model.url componentsSeparatedByString:@"/"] lastObject];
    taobao.urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/items/%@",string];
    [taobao setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:taobao animated:YES];
}


@end
