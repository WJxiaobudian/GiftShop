//
//  GSPurchaseController.m
//  GiftShop
//
//  Created by WJ on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSPurchaseController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
@interface GSPurchaseController ()<UIWebViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *webView;


@end

@implementation GSPurchaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addWebView];
}

- (void)addWebView  {

    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.backgroundColor = [UIColor whiteColor];
    
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[AFHTTPSessionManager manager] GET:self.purchaseString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [SVProgressHUD dismiss];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:responseObject[@"data"][@"purchase_url"]]];
        [self.webView loadRequest:request];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.purchaseString]];
//    [self.webView loadRequest:request];
}


- (void)closeClick {
    NSLog(@"afdfa");
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
