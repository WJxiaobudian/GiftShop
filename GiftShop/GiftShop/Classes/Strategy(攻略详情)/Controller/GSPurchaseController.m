//
//  GSPurchaseController.m
//  GiftShop
//
//  Created by WJ on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSPurchaseController.h"

@interface GSPurchaseController ()<UIWebViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIView *webBrowserView;

@property (nonatomic, strong) UIImageView *headerImageView;


@end

@implementation GSPurchaseController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = XMGGlobalBg;
    [self addWebView];
}

- (void)addWebView  {

    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.backgroundColor = [UIColor whiteColor];
    
    self.webView.scrollView.delegate = self;
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    
    
    self.webBrowserView = self.webView.scrollView.subviews[0];
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.backgroundColor = [UIColor redColor];
    [self.webView addSubview:nav];
    
    CGRect frame = self.webBrowserView.frame;
    frame.origin.y = CGRectGetMaxY(nav.frame);
    self.webBrowserView.frame = frame;
    
    [self.view sendSubviewToBack:nav];
    
    [self.view bringSubviewToFront:nav];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 30, 20, 20);
    [button setImage:[UIImage imageNamed:@"login_close_icon"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 40, 30, 80, 20)];
    label.text = @"商品详情";
    label.textColor = [UIColor whiteColor];
    [nav addSubview:label];
    
    
    [SVProgressHUD showWithStatus:@"正在加载"];

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[AFHTTPSessionManager manager] GET:self.purchaseString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
     
       
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:responseObject[@"data"][@"purchase_url"]]];
        [self.webView loadRequest:request];
        
        
         [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"数据加载错误"];
        
    }];
}

- (void)closeClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
