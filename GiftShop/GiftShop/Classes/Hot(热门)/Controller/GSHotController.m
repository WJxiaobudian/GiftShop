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
#import "GSTaoBaoController.h"


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
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"204" target:self action:@selector(searchClick)];

}

- (void)searchClick {
    GSSearchController *search = [[GSSearchController alloc] init];
    
    [self.navigationController pushViewController:search animated:YES];
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
            
//            if (![model.cover_image_url hasSuffix:@"jpg-w720"]) {
//                [self.dataArray removeObject:model];
//            }
        }
        
        if (self.dataArray != nil && ![self.dataArray isKindOfClass:[NSNull class]] && self.dataArray.count != 0) {
            [self.hv.listCollectionView reloadData];
            [self.hv.listCollectionView.mj_header endRefreshing];
        }
       
        
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
