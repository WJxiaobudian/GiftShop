//
//  GSTaoBaoController.m
//  GiftShop
//
//  Created by WJ on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSTaoBaoController.h"
#import "GSPurchaseController.h"
#import "GSTabBarView.h"
#import "GSTaobao.h"
#import "GSHotCell.h"
#import "GSHotModel.h"
@interface GSTaoBaoController ()<UIWebViewDelegate, UIScrollViewDelegate,SDCycleScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) SDCycleScrollView *scrollView;


@property (nonatomic, strong) NSMutableArray *imageArray;


@property (nonatomic, strong) NSMutableArray *taoBaoArray;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) GSTabBarView *lineView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *bgView;


@end

static NSString * const reuseIdentifier = @"item_id";

@implementation GSTaoBaoController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray ) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)taoBaoArray {
    if (!_taoBaoArray) {
        _taoBaoArray = [NSMutableArray array];
    }
    return _taoBaoArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"商品详情";
    [self addWebView];
    
    [self loadData];
    
    self.view.backgroundColor = XMGGlobalBg;
    
    self.size = CGSizeMake(ScreenWidth/2 - 20, ScreenWidth/2 + 70);
    
    
    [self loadCollectionView];
    
    
}

- (void)addWebView {

#pragma mark --- 底部显示栏
    GSTabBarView *lineView = [GSTabBarView first];
    lineView.frame = CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44);
    self.lineView  = lineView;
    lineView.backgroundColor = XMGGlobalBg;
    [self.view addSubview:lineView];
    
    // 底部显示栏button的点击事件
    [lineView.shopButton addTarget:self action:@selector(taoBaoButton) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark --webView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight - 44- 60)];
    self.webView = webView;
    self.webView.delegate = self;
    webView.opaque = NO;
    webView.backgroundColor = XMGGlobalBg;
    [self.view addSubview:webView];
    
#pragma mark -- ScrollView
    webView.scrollView.contentInset = UIEdgeInsetsMake(500, 0, 0, 0);
    webView.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.backgroundColor = XMGGlobalBg;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -500, ScreenWidth, 500)];
    view.backgroundColor = [UIColor whiteColor];
    self.bgView = view;
    [self.webView.scrollView addSubview:view];
    
#pragma mark --- 第三方轮播图
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.webView.width, 350) delegate:self placeholderImage:nil];
    self.scrollView.currentPageDotColor = [UIColor whiteColor];
    [view addSubview:self.scrollView];
    
#pragma mark --- 商品名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.scrollView.frame)+10, ScreenWidth, 20)];
    nameLabel.font = [UIFont systemFontOfSize:20];
    self.nameLabel = nameLabel;
    [view addSubview:nameLabel];
    
#pragma mark --- 价格
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame) + 10, ScreenWidth, 20)];
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textColor = [UIColor redColor];
    self.moneyLabel = moneyLabel;
    [view addSubview:moneyLabel];
    
#pragma mark --- 商品介绍
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(moneyLabel.frame) + 10, ScreenWidth - 20 , 10)];
    titleLabel.numberOfLines = 0;

    titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel = titleLabel;
    [view addSubview:titleLabel];
    
    
    
}

- (void)loadData {

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[AFHTTPSessionManager manager] GET:self.urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
     
        // 头部轮播图
        self.imageArray = dict[@"image_urls"];
        self.scrollView.autoScroll = NO;
        self.scrollView.imageURLStringsGroup = self.imageArray;
        
        // 详情页面
        [self.webView loadHTMLString:dict[@"detail_html"] baseURL:nil];
        
        // 商品名称
       self.nameLabel.text = dict[@"name"];
        
        // 商品价格
       self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",dict[@"price"]];
        
        // 商品介绍
       self.titleLabel.text = dict[@"description"];
        
        CGSize size = CGSizeMake(ScreenWidth - 20, 20000);
        CGRect rect = [self.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        CGRect frame = self.titleLabel.frame;
        frame.size = rect.size;
        self.titleLabel.frame = frame;

        CGFloat height = 450 + rect.size.height;
        
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
        self.bgView.frame = CGRectMake(0, - height, ScreenWidth, height);
    
        
        // 商品购买地址
        [self.lineView.shopButton setTitle:[NSString stringWithFormat:@"%@",dict[@"source"][@"button_title"]] forState:UIControlStateNormal];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"数据加载错误"];
    }];
}

// 点击事件
- (void)taoBaoButton {
    
    GSPurchaseController *purchase = [[GSPurchaseController alloc] init];
    
    purchase.purchaseString = self.urlString;
    
    [self presentViewController:purchase animated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return  YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
 
    webView.scrollView.contentInset = UIEdgeInsetsMake(500, 0, self.size.height * (self.dataArray.count / 2) + 100 , 0);
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,height + 20, ScreenWidth, 20)];
    label.text = @"—————— 你可能也喜欢 ——————";
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.webView.scrollView addSubview:label];
    
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, height + 50, ScreenWidth, self.size.height * (self.dataArray.count / 2) + 150 ) collectionViewLayout:flowLayout];
    
   
   
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView setBackgroundColor:[UIColor colorWithWhite:0.902 alpha:1.000]];
 
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GSHotCell class]) bundle: nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.webView.scrollView addSubview:self.collectionView];

}

- (void)loadCollectionView {
    
    NSString *num = [[self.urlString componentsSeparatedByString:@"/"] lastObject];
    
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/items/%@/recommend", num];
    
    [[AFHTTPSessionManager manager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
     
        NSArray *array = responseObject[@"data"][@"recommend_items"];
        for (NSDictionary *dict in array) {
            GSHotModel *giftShop = [[GSHotModel alloc] initWithDict:dict];
            [self.dataArray addObject:giftShop];
           
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.size;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 10, 15);
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
    
    GSHotModel *model = self.dataArray[indexPath.row];
    
    GSTaoBaoController *taobao = [[GSTaoBaoController alloc] init];
    
    taobao.urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/items/%@", model.Nid];
    
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
