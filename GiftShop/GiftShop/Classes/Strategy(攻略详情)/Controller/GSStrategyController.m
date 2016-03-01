//
//  GSStrategyController.m
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSStrategyController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"


@interface GSStrategyController ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UITableView *tabelView;


@end

@implementation GSStrategyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"攻略详情";
    [self setupWebView];

}

- (void)setupWebView {

#pragma mark --- webView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView = webView;
    webView.opaque = YES;

    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
    
#pragma mark --- ScrollView imageView
    webView.scrollView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    webView.scrollView.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, self.webView.width, 200)];
    [webView.scrollView addSubview:image];
    
    [image sd_setImageWithURL:[NSURL URLWithString:self.cover_webp_url]];
    
#pragma mark ---- TitleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 ,image.height - 70 , webView.width - 15 * 2, 70)];
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:25];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    self.titleLabel = titleLabel;
    [image addSubview:titleLabel];
 
#pragma mark ---- lineLabel
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.webView.height, self.webView.width, 4)];
    lineLabel.text = @"-------------- 你可能喜欢 --------------- ";
    lineLabel.textAlignment = NSTextAlignmentCenter;
    self.lineLabel = lineLabel;
    lineLabel.backgroundColor = [UIColor redColor];
//    [webView.scrollView addSubview:lineLabel];
    
}



@end
