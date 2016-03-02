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
#import "GSDetailViewController.h"
#define URL @"http://api.liwushuo.com/v2/items?gender=1&generation=1&limit=50&offset=0"
static NSString *identifier = @"item_id";
@interface GSHotController ()<UICollectionViewDataSource, UICollectionViewDelegate>
// 用来保存解析出来的数据
@property (nonatomic, strong) NSMutableArray *dataArray;
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
    [self loadData];

}
#pragma mark 加载数据
- (void)loadData {
    self.dataArray = [NSMutableArray array];
    
    [GT_NetTools solveDataWithUrl:URL HttpMethod:@"GET" HttpBody:nil revokeBlock:^(NSData *data) {
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
    [self.navigationController pushViewController:dvc animated:YES];
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
