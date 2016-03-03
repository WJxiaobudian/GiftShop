//
//  GSDetailViewController.m
//  GiftShop
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSDetailViewController.h"
#import "UIImageView+WebCache.h"
@interface GSDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
// 头部的scrollView
@property (nonatomic, strong) UIScrollView *topScrollView;

@end

@implementation GSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backHot)];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = right;
    // 初始化
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 480)];
    self.topScrollView.backgroundColor = [UIColor redColor];

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, self.view.bounds.size.height+100)];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.model.url]];
    [self.webView loadRequest:request];
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    [self.webView.scrollView addSubview:self.topScrollView];

    self.webView.delegate = self;
    // 设置底部的view
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY([UIScreen mainScreen].bounds) - 56, self.view.frame.size.width, 56)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    // Do any additional setup after loading the view.
}
// 左边item的按钮响应
- (void)backHot {
    [self.navigationController popViewControllerAnimated:YES];
}

// 右边item的按钮响应
- (void)shareAction {
    
}

#pragma mark UIWebView的代理方法
// 开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
}
// 加载结束
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}
// 加载出现错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
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
