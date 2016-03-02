//
//  GSDetailViewController.m
//  GiftShop
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSDetailViewController.h"
@interface GSDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation GSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.model.url]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    // 自适应屏幕的宽度
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    // Do any additional setup after loading the view.
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
