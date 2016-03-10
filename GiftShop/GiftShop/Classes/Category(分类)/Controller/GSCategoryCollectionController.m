//
//  GSCategoryCollectionController.m
//  GiftShop
//
//  Created by WJ on 16/3/7.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryCollectionController.h"
#import "GSHotCell.h"
#import "GSTaoBaoController.h"
#import "GSHotModel.h"
@interface GSCategoryCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger offset;

@end

@implementation GSCategoryCollectionController

static NSString * const reuseIdentifier = @"item_id";


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.name;
    
    self.view.backgroundColor = XMGGlobalBg;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight ) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView setBackgroundColor:[UIColor colorWithWhite:0.902 alpha:1.000]];
    //    [self addRefresh];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GSHotCell class]) bundle: nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    [self addRefresh];
}


- (void)addRefresh {
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadNewData {
    
    [self.collectionView.mj_footer endRefreshing];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    self.offset = 0;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"offset"] = @(self.offset);
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/item_subcategories/%@/items?limit=20", self.urlID];
    [[AFHTTPSessionManager manager] GET:string parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        [self.dataArray removeAllObjects];
        NSDictionary *dict = responseObject[@"data"];
        for (NSDictionary *dic in dict[@"items"]) {

            GSHotModel *model = [[GSHotModel alloc] initWithDict:dic];
            
            [self.dataArray addObject:model];
            
            if (![model.cover_image_url hasSuffix:@"jpg-w720"]) {
                [self.dataArray removeObject:model];
            }
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"数据加载错误"];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    
    [self.collectionView.mj_header endRefreshing];
    self.offset += 20;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"offset"] = @(self.offset);
    
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/item_subcategories/%@/items?limit=20", self.urlID];
    [[AFHTTPSessionManager manager] GET:string parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        for (NSDictionary *dic in dict[@"items"]) {

            GSHotModel *model = [[GSHotModel alloc] initWithDict:dic];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
    }];
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth/2 - 20, ScreenWidth/2 + 70);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(-60, 15, 10, 15);
}


#pragma mark 实现代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
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
