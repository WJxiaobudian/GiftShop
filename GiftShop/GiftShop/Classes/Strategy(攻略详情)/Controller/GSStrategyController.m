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
#import "GSTaoBaoController.h"
#import "SVProgressHUD.h"
@interface GSStrategyController ()<UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UITableView *tabelView;

@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *numArray;

@end

@implementation GSStrategyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"攻略详情";

    [self setupWebView];

}

- (void)setupWebView {
 
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

#pragma mark --- webView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView = webView;
    webView.opaque = NO;
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self.view addSubview:self.webView];
    
#pragma mark --- ScrollView imageView
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.contentInset = UIEdgeInsetsMake(150 + 64, 0, 64, 0);
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 - 150, self.webView.width, 150)];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.tag = 101;
    self.image = image;
    [webView.scrollView addSubview:image];
    
    
#pragma mark ---- TitleLabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15 , 140 , webView.width - 15 * 2, 70)];
    [self.image addSubview:label];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textColor = [UIColor whiteColor];
    
    self.label = label;
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    self.numArray = [NSMutableArray array];
    [[AFHTTPSessionManager manager] GET:self.urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        self.numArray = responseObject[@"data"][@"item_ad_monitors"];
        [self.webView loadHTMLString:responseObject[@"data"][@"content_html"] baseURL:nil];
       [self.image sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"cover_webp_url"]]];
        
        label.text = self.titleLabel;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    GSTaoBaoController *taoBao = [[GSTaoBaoController alloc] init];
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        NSLog(@"%@",url);
        NSString *string = [[[NSString stringWithFormat:@"%@",url] componentsSeparatedByString:@"/"]lastObject];
        NSLog(@"%@",string);
        taoBao.urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/items/%@",string];
        [self.navigationController pushViewController:taoBao animated:YES];
        return NO;
    }
    return YES;
}

@end
