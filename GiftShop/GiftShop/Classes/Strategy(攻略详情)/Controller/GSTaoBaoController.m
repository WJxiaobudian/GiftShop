//
//  GSTaoBaoController.m
//  GiftShop
//
//  Created by WJ on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSTaoBaoController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "GSPurchaseController.h"
#import "GSLoginController.h"
#import "GSTabBarView.h"
#import "SVProgressHUD.h"
#import "GSTaobao.h"
#import "SDCycleScrollView.h"
@interface GSTaoBaoController ()<UIWebViewDelegate, UIScrollViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) SDCycleScrollView *scrollView;


@property (nonatomic, strong) NSMutableArray *imageArray;


@property (nonatomic, strong) NSMutableArray *taoBaoArray;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextView *titleLabel;

@property (nonatomic, strong) GSTabBarView *lineView;

@end

@implementation GSTaoBaoController


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
}

- (void)addWebView {

#pragma mark --- 底部显示栏
    GSTabBarView *lineView = [GSTabBarView first];
    lineView.frame = CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44);
    self.lineView  = lineView;
    [self.view addSubview:lineView];
    
    // 底部显示栏button的点击事件
    [lineView.shopButton addTarget:self action:@selector(taoBaoButton) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark --webView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight - 44- 60)];
    self.webView = webView;
    self.webView.delegate = self;
    webView.opaque = NO;
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    
#pragma mark -- ScrollView
    webView.scrollView.contentInset = UIEdgeInsetsMake(500, 0, 0, 0);
    webView.backgroundColor = [UIColor whiteColor];
    
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
#pragma mark --- 第三方轮播图
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -500, self.webView.width, 350) delegate:self placeholderImage:nil];
    self.scrollView.currentPageDotColor = [UIColor whiteColor];
    [webView.scrollView addSubview:self.scrollView];
    
#pragma mark --- 商品名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.scrollView.frame)+5, ScreenWidth, 20)];
    nameLabel.font = [UIFont systemFontOfSize:20];
    self.nameLabel = nameLabel;
    [webView.scrollView addSubview:nameLabel];
    
#pragma mark --- 价格
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame) + 5, ScreenWidth, 20)];
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textColor = [UIColor redColor];
    self.moneyLabel = moneyLabel;
    [webView.scrollView addSubview:moneyLabel];
    
#pragma mark --- 商品介绍
    UITextView *titleLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(moneyLabel.frame), ScreenWidth - 20 , 100)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel = titleLabel;
    [webView.scrollView addSubview:titleLabel];
    
   
}

- (void)loadData {
//    [SVProgressHUD showWithStatus:@"正在加载"];
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
//        
//        self.taobaoUrl = dict[@"purchase_url"];
        
        // 商品购买地址
        [self.lineView.shopButton setTitle:[NSString stringWithFormat:@"%@",dict[@"source"][@"button_title"]] forState:UIControlStateNormal];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"数据加载错误"];
    }];
}

// 点击时间
- (void)taoBaoButton {
    
    GSPurchaseController *purchase = [[GSPurchaseController alloc] init];
    
    purchase.purchaseString = self.urlString;
    
    [self.navigationController pushViewController:purchase animated:YES];
}

@end
