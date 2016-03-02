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


@interface GSStrategyController ()<UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UITableView *tabelView;

@property (nonatomic, strong) UIImageView *image;


@end

@implementation GSStrategyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"攻略详情";
//    NSLog(@"%@",self.cover_webp_url);
    [self setupWebView];

}

- (void)setupWebView {
 
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

#pragma mark --- webView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView = webView;
    webView.backgroundColor = [UIColor clearColor];
    webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
    
#pragma mark --- ScrollView imageView
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.contentInset = UIEdgeInsetsMake(150 + 64, 0, 0, 0);
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 - 150, self.webView.width, 150)];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.tag = 101;
    self.image = image;
    [webView.scrollView addSubview:image];
    
    [image sd_setImageWithURL:[NSURL URLWithString:self.cover_webp_url]];
//    NSLog(@"%@",self.cover_webp_url);
    
#pragma mark ---- TitleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 , 140 , webView.width - 15 * 2, 70)];
    [self.image addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:25];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
     self.titleLabel = titleLabel;

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint point = scrollView.contentOffset;
    if (point.y < -200) {
        CGRect rect = [self.webView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.webView viewWithTag:101].frame = rect;

    }
}
@end
