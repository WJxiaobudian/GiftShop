//
//  GSHotController.m
//  GiftShop
//
//  Created by WJ on 16/2/29.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSHotController.h"
#import "GSHotCell.h"
#import "GT_NetTools.h"
#import "GSHotModel.h"
#import "FCXRefreshFooterView.h"
#import "UIScrollView+FCXRefresh.h"
#import "GSDetailViewController.h"
#define URL @"http://api.liwushuo.com/v2/items?gender=1&generation=1&limit=50&offset="
static NSString *identifier = @"item_id";
@interface GSHotController ()<UICollectionViewDataSource, UICollectionViewDelegate>
// 用来保存解析出来的数据
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) FCXRefreshFooterView *footerView;
// 记录url中page的值从而改变数据的变化
@property (nonatomic, assign) NSInteger page;
@end

@implementation GSHotController

- (void)loadView {
    [super loadView];
    self.hv = [[GSHotView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.hv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置代理
    self.hv.listCollectionView.delegate = self;
    self.hv.listCollectionView.dataSource = self;
    // 注册item
    [self.hv.listCollectionView registerNib:[UINib nibWithNibName:@"GSHotCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    // 调用加载数据的方法
    [self loadData:0];
    // 调用上拉加载
    [self addRefreshView];

}
#pragma mark 下拉刷新和上拉加载更多
- (void)addRefreshView {
    __weak __typeof(self)weakSelf = self;
    // 上拉加载更多
    _footerView = [self.hv.listCollectionView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadMoreAction];
    }];
}
// 上拉加载
- (void)loadMoreAction {
    __weak UICollectionView *weakCollectionView = self.hv.listCollectionView;
    __weak FCXRefreshFooterView *weakFooterView = _footerView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData:_page+=50];
        [weakCollectionView reloadData];
        [weakFooterView endRefresh];
    });
}

#pragma mark 加载数据
- (void)loadData:(NSInteger)page {
    self.dataArray = [NSMutableArray array];
    [GT_NetTools solveDataWithUrl:[NSString stringWithFormat:@"%@"@"%ld", URL, page] HttpMethod:@"GET" HttpBody:nil revokeBlock:^(NSData *data) {
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSMutableDictionary *dict = dictionary[@"data"];
        for (NSDictionary *dic in dict[@"items"]) {
            NSMutableDictionary *di = dic[@"data"];
            GSHotModel *model = [[GSHotModel alloc] init];
            [model setValuesForKeysWithDictionary:di];
            [self.dataArray addObject:model];
        }
        [self.hv.listCollectionView reloadData];
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
    
    GSDetailViewController *dvc = [[GSDetailViewController alloc] init];
    dvc.model = self.dataArray[indexPath.row];
    [dvc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:dvc animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
