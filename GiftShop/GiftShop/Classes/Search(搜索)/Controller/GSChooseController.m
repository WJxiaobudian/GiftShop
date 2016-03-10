//
//  GSChooseController.m
//  GiftShop
//
//  Created by WJ on 16/3/5.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSChooseController.h"
#import "GSHotModel.h"
#import "GSHotCell.h"
#import "GSTaoBaoController.h"
#import "GSSearch.h"
#import "GSSearchList.h"
@interface GSChooseController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *titlesView;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic, strong) NSMutableArray *nameArray;


@property (nonatomic, copy) NSString *target;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *scene;

@property (nonatomic, copy) NSString *personality;

@property (nonatomic, strong) UIButton *listButton;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, assign) NSInteger count;


@end

static NSString * CellIdentifier = @"item_id";

@implementation GSChooseController

- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor = XMGGlobalBg;
    
     [self setupTitlesView];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, ScreenHeight-44 ) collectionViewLayout:flowLayout];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView setBackgroundColor:[UIColor colorWithWhite:0.902 alpha:1.000]];
      [self addRefresh];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GSHotCell class]) bundle: nil] forCellWithReuseIdentifier:CellIdentifier];
    
    [self.view addSubview:self.collectionView];
    
    [self addRefresh];
    
    [self setAllName];
    
   self.count = 1;
    
}

- (void)setupTitlesView {
    
    
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 36)];
    titlesView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    for (int i = 1; i < 4; i ++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/4 * i , 0, 1, titlesView.height)];
        image.image = [UIImage imageNamed:@"cell-button-line"];
        [self.titlesView addSubview:image];
        
    }
    
    [titlesView addSubview:indicatorView];
    
    // 内部的子标签
    CGFloat width = titlesView.width / 4;
    CGFloat height = 36;
    
    NSArray * array = @[@"对象", @"场合", @"个性", @"价格"];
    
    for (NSInteger i = 0; i<4; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        button.tag = i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        self.listButton = button;
        [titlesView addSubview:button];
      
    }
}

- (void)setAllName {
    
    [[AFHTTPSessionManager manager]GET:@"http://api.liwushuo.com/v2/search/item_filter" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = responseObject[@"data"][@"filters"];
        for (NSDictionary *dict in array) {
            GSSearch *search = [[GSSearch alloc] initWithDict:dict];
            [self.searchArray addObject:search];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)titleClick:(UIButton *)sender {
    
    self.listButton = sender;
    if (self.selectedButton == sender) {
        [self.searchView removeFromSuperview];
        self.selectedButton = nil;
        return;
    }

    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = sender.width;
        self.indicatorView.centerX = sender.centerX;
    }];

    [self.searchView removeFromSuperview];
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 150)];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    self.searchView = searchView;
    
    
    CGFloat X = 10;
    CGFloat Y = 10;
    CGFloat W = (ScreenWidth - 40) / 3;
    CGFloat H = 35;
    
    GSSearch *search = self.searchArray[sender.tag];

    for (int i = 0; i < search.channels.count  ; i ++) {
        NSInteger line = i / 3;
        NSInteger row = i % 3;
        
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        searchButton.layer.borderWidth = 1;
        
        [self.searchView addSubview:searchButton];
        
        searchButton.frame = CGRectMake(row  *(W + X) + X , line * (H + Y) + X, W, H);
        
        [searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        searchButton.tag = i;
        searchButton.layer.borderColor = [UIColor blackColor].CGColor;
        
        
        GSSearchList *list = search.channels[i];
        
        [searchButton setTitle:list.name forState:UIControlStateNormal];
        
    }
    
    self.selectedButton = sender;
    
    if (self.coverView) {
        return;
    }
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    coverView.backgroundColor = [UIColor whiteColor];
    
    coverView.alpha = 0.2;
    
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    
    [self.collectionView addSubview:coverView];
    
    self.coverView = coverView;
    
    
    
}

- (void) tapClick {
    self.searchView.hidden = YES;
    self.searchView = nil;
    self.coverView.hidden = YES;
    self.coverView = nil;
}

- (void)search:(UIButton *)button {

    self.count = 1;
    GSSearch *search = self.searchArray[self.listButton.tag];
    GSSearchList *list = search.channels[button.tag ];

    [self.listButton setTitle:button.titleLabel.text forState:UIControlStateNormal];

    switch (self.listButton.tag) {
        case 0:
            
            self.target = list.key;
            
            break;
            
        case 1:
            self.scene = list.key;
            
            break;
            
        case 2:
            self.personality = list.key;
            break;
            
        case 3:
            self.price = list.key;
            
        default:

            break;
    }
    
    [self addRefresh];
    [self.searchView removeFromSuperview];
    [self.coverView removeFromSuperview];
    
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GSHotCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    GSHotModel *model = self.dataArray[indexPath.row];

    cell.model = model;
    
    return cell;
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
    return UIEdgeInsetsMake(0, 15, 10, 15);
}

#pragma mark --UICollectionViewDelegate


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
    
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/search/item_by_type?limit=20&personality=%@&price=%@&scene=%@&target=%@",self.personality, self.price, self.scene, self.target];
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"offset"] = @(self.offset);

    [[AFHTTPSessionManager manager] GET:string parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
     
        [self.dataArray removeAllObjects];
        NSDictionary *dict = responseObject[@"data"];
    
        for (NSDictionary *dic in dict[@"items"]) {
            GSHotModel *model = [[GSHotModel alloc] initWithDict:dic];
            [self.dataArray addObject:model];
        }
       
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"数据加载错误"];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    
    if (self.dataArray.count < (20 *(self.count))) {
        return;
    }
    [self.collectionView.mj_header endRefreshing];
    self.offset += 20;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"offset"] = @(self.offset);
    
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/search/item_by_type?limit=20&personality=%@&price=%@&scene=%@&target=%@",self.personality, self.price, self.scene, self.target];
    
    [[AFHTTPSessionManager manager] GET:string parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        for (NSDictionary *dic in dict[@"items"]) {
            GSHotModel *model = [[GSHotModel alloc] initWithDict:dic];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
        
        self.count ++;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GSTaoBaoController *taobao = [[GSTaoBaoController alloc] init];
    GSHotModel *model = self.dataArray[indexPath.row];
    taobao.urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/items/%@",model.Nid];
    [taobao setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:taobao animated:YES];
}

- (void)dealloc {
    
     [self.manager.operationQueue cancelAllOperations];
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
