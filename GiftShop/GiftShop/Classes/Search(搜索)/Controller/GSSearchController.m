//
//  GSSearchController.m
//  GiftShop
//
//  Created by WJ on 16/3/4.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSSearchController.h"
#import "GSGiftShop.h"
#import "GSGiftShopCell.h"
#import "GSStrategyController.h"
#import "GSHotCell.h"
#import "GSHotModel.h"
#import "GSTaoBaoController.h"
#import "GSChooseController.h"

@interface GSSearchController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;


@property (nonatomic, strong) UIView *firstView;

@property (nonatomic, strong) UIView *labelView;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UIView *titlesView;

@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataCollectionArray;

@property (nonatomic, assign) NSInteger tableOffset;

@property (nonatomic, assign) NSInteger collectionOffset;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation GSSearchController

- (NSMutableArray *)dataCollectionArray {
    if (!_dataCollectionArray) {
        _dataCollectionArray = [NSMutableArray array];
    }
    return _dataCollectionArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = XMGGlobalBg;
    
    [self addSearchBar];
    
    [self addSearchView];
    
}

- (void)tap {

    [self.searchBar resignFirstResponder];
}

// 第一个界面
- (void)addFirstView {
    
    self.firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    self.firstView.backgroundColor = XMGGlobalBg;
    [self.view addSubview:self.firstView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.cancelsTouchesInView = NO;
    [self.firstView addGestureRecognizer:tap];
    
    [self setupAllButton];
    
    [self setLineButton];
}

- (void)setLineButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed:@"FollowBtnBg"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(chooseClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, ScreenWidth, 50);
    
    button.backgroundColor = [UIColor whiteColor];
    [self.firstView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth - 40, button.height)];
    label.text = @"使用快速选择神器获得心怡的礼物";
    [button addSubview:label];
    
    UILabel *image = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 20, 0, 20, button.height)];
    image.text = @">";
    [button addSubview:image];
    
}

- (void)chooseClick {
    GSChooseController *choose = [[GSChooseController alloc] init];
    
    [self.navigationController pushViewController:choose animated:YES];
}

- (void)setupAllButton {
    
    
    
    [[AFHTTPSessionManager manager]GET:@"http://api.liwushuo.com/v2/search/hot_words" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
        [self.buttonArray removeAllObjects];
        NSArray *array = responseObject[@"data"][@"hot_words"];
        
        for (NSString *string in array) {
            
            [self.buttonArray addObject:string];
        }

    CGFloat X = 10;
    CGFloat Y = 150;
    CGFloat W = (ScreenWidth - 40 )/3;
    CGFloat H = 30;
   
    for (int i = 0; i < self.buttonArray.count ; i ++) {
        
        NSInteger line = i / 3;
        NSInteger row =  i % 3;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
       
        [button setTitle:self.buttonArray[i] forState:UIControlStateNormal];
        [UIView animateWithDuration:2.0 animations:^{
            button.frame = CGRectMake(row *(W + X) + X , line * (H + X + 30) + Y, W, H);
            [self.view addSubview:button];
            
            button.titleLabel.font = [UIFont systemFontOfSize:arc4random()%20 + 15];
            [button setTitleColor:[UIColor colorWithRed:arc4random()%255/256.0 green:arc4random()%255/256.0 blue:arc4random()%255/256.0 alpha:1.0] forState:UIControlStateNormal];
        }];
        
        [button addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
       
    }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)searchClick:(UIButton *)button {
    
    self.searchBar.text = button.titleLabel.text;

    [self searchBarSearchButtonClicked:self.searchBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.searchBar becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.searchBar resignFirstResponder];
    
}

- (void)addSearchBar {
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    self.searchBar.delegate = self;

    searchBar.placeholder = @"快速挑选礼物";
}

// 第二个界面
- (void)addSearchView {
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight )];
    
    searchView.backgroundColor = [UIColor redColor];
    self.searchView = searchView;
    
    [self.view addSubview:searchView];
    
    [self setChildController];
}



// 当点击search的时候调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   
    [searchBar resignFirstResponder];
    
    [self.view bringSubviewToFront:self.searchView];
    [self setRefreshCollection];
    
    [self setRefreshTable];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    [self addFirstView];

    return YES;
}


- (void)setChildController {

    [self setupTitlesView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,-35, ScreenWidth, ScreenHeight + 35) style:UITableViewStylePlain];
    [self.searchView addSubview:self.tableView ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  
    layout.itemSize = CGSizeMake(self.searchView.width/2 - 20, self.searchView.width/2 + 70);
  
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth, ScreenHeight - 50 ) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.searchView addSubview:self.collectionView];
    
       [self.searchView insertSubview:self.collectionView aboveSubview:self.tableView];
  
    [self.searchView bringSubviewToFront:self.titlesView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GSHotCell" bundle:nil] forCellWithReuseIdentifier:@"item_id"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GSGiftShopCell class]) bundle:nil] forCellReuseIdentifier:@"GiftShop"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];

}


- (void)setRefreshTable {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTabelNewData)];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTabelData)];
}

- (void)loadTabelNewData {
    
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    self.tableOffset = 0;
    parameter[@"offset"] = @(self.tableOffset);

    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/search/post?keyword=%@&limit=20&sort=",[self.searchBar.text   stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];

    [[AFHTTPSessionManager manager] GET:string parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
     
        [self.dataArray removeAllObjects];
        NSArray *array = responseObject[@"data"][@"posts"];
        for (NSDictionary *dict in array) {
            GSGiftShop *gift = [[GSGiftShop alloc] initWithDict:dict];
            [self.dataArray addObject:gift];
            
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreTabelData {
    
    [self.tableView.mj_header endRefreshing];
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/search/post?keyword=%@&limit=20&sort=",[self.searchBar.text   stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    self.tableOffset += 20;
    parameter[@"offset"] = @(self.tableOffset);
    
    
    [[AFHTTPSessionManager manager] GET:string parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = responseObject[@"data"][@"posts"];
        for (NSDictionary *dict in array) {
            GSGiftShop *gift = [[GSGiftShop alloc] initWithDict:dict];
            
            [self.dataArray addObject:gift];
            
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
- (void)setupTitlesView {
    
    
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    titlesView.backgroundColor = [UIColor whiteColor];
    
    [self.searchView addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, 1, titlesView.height)];
    image.image = [UIImage imageNamed:@"cell-button-line"];
    [self.titlesView addSubview:image];
    
    [titlesView addSubview:indicatorView];
    // 内部的子标签
    CGFloat width = titlesView.width / 2;
    CGFloat height = 35;
    
    NSArray *array = @[@"礼   物", @"攻   略"];
    
    for (NSInteger i = 0; i<2; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        [button setTitle:array[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
      
            [button.titleLabel sizeToFit];
            self.indicatorView.width = width;
        }
    }
}

- (void)titleClick:(UIButton *)button
{
    switch (button.tag) {
        case 0:
        {
            
            [self.searchView insertSubview:self.collectionView aboveSubview:self.tableView];
            [self.searchView bringSubviewToFront:self.titlesView];

            
        }
            break;
        case 1:
        {
            [self.searchView insertSubview:self.tableView aboveSubview:self.collectionView];
            [self.searchView bringSubviewToFront:self.titlesView];
            
        }
        default:
            break;
    }
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.width;
        self.indicatorView.centerX = button.centerX;
    }];
}

- (void)setRefreshCollection {
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCollectionNewData)];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadCollectionMoreData)];
    
}
- (void)loadCollectionNewData {
    
    [self.collectionView.mj_footer endRefreshing];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    self.collectionOffset = 0;
    parameter[@"offset"] = @(0);
    
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/search/item?keyword=%@&limit=20&sort=",[self.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    [[AFHTTPSessionManager manager] GET:string parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
         [self.dataCollectionArray removeAllObjects];
       
        NSArray *array = responseObject[@"data"][@"items"];
        for (NSDictionary *dict in array) {
            GSHotModel *gift = [[GSHotModel alloc] initWithDict:dict];
            [self.dataCollectionArray addObject:gift];
            
            [self.collectionView reloadData];
        }
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        
    }];
}

- (void)loadCollectionMoreData {
    [self.collectionView.mj_header endRefreshing];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    self.collectionOffset += 20;
    parameter[@"offset"] = @(self.collectionOffset);
    
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/search/item?keyword=%@&limit=20&sort=",[self.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [[AFHTTPSessionManager manager] GET:string parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = responseObject[@"data"][@"items"];
        for (NSDictionary *dict in array) {
            GSHotModel *gift = [[GSHotModel alloc] initWithDict:dict];
            [self.dataCollectionArray addObject:gift];
            
            [self.collectionView reloadData];
        }
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.collectionView.mj_footer endRefreshing];
    }];
    
    
}
#pragma  mark -- CollectionViewDelegate

#pragma mark 实现代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataCollectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item_id" forIndexPath:indexPath];
    GSHotModel *model = self.dataCollectionArray[indexPath.item];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GSTaoBaoController *taobao = [[GSTaoBaoController alloc] init];
    GSHotModel *model = self.dataCollectionArray[indexPath.row];
    taobao.urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/items/%@",model.Nid];
    
    [self.navigationController pushViewController:taobao animated:YES];
}


#pragma mark --- TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSGiftShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftShop"];
    
    cell.giftShop = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSStrategyController *strategy = [[GSStrategyController alloc] init];
    
    GSGiftShop *gift = self.dataArray[indexPath.row];
    strategy.urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/posts/%@",gift.userId];
    
    [self.navigationController pushViewController:strategy animated:YES];
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
