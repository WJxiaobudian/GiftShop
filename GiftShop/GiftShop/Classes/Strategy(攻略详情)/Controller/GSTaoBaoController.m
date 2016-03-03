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
@interface GSTaoBaoController ()<UIWebViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSString *taobaoUrl;



@end

@implementation GSTaoBaoController

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addWebView];
    

}

- (void)addWebView {

    GSTabBarView *lineView = [GSTabBarView first];
    lineView.frame = CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44);
    [self.view addSubview:lineView];
    
    [lineView.shopButton addTarget:self action:@selector(taoBaoButton) forControlEvents:UIControlEventTouchUpInside];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, ScreenHeight - 44- 30)];
    self.webView = webView;
    self.webView.delegate = self;
    webView.opaque = NO;
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    
    webView.scrollView.contentInset = UIEdgeInsetsMake(500, 0, 0, 0);
    webView.backgroundColor = [UIColor whiteColor];
    
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, -500, self.webView.width, 300)];
    image.contentMode =UIViewContentModeScaleAspectFill;
    self.image = image;
    [webView.scrollView addSubview:image];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(image.frame) + 64 + 5, ScreenWidth, 20)];
    nameLabel.font = [UIFont systemFontOfSize:20];
    [webView.scrollView addSubview:nameLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame) + 5, ScreenWidth, 20)];
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textColor = [UIColor redColor];
    [webView.scrollView addSubview:moneyLabel];
    
    UITextView *titleLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(moneyLabel.frame), ScreenWidth - 20 , 100)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [webView.scrollView addSubview:titleLabel];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[AFHTTPSessionManager manager] GET:self.urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
        [SVProgressHUD dismiss];
        NSLog(@"%@",responseObject);
        NSMutableArray *array = responseObject[@"data"][@"image_urls"];
        [self.imageArray addObject:array];
        [self.webView loadHTMLString:responseObject[@"data"][@"detail_html"] baseURL:nil];
        [self.image sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"cover_webp_url"]]];
        nameLabel.text = responseObject[@"data"][@"name"];
        moneyLabel.text = [NSString stringWithFormat:@"￥%@",responseObject[@"data"][@"price"]];
        titleLabel.text = responseObject[@"data"][@"description"];
        self.taobaoUrl = responseObject[@"data"][@"purchase_url"];
        NSDictionary *dict = responseObject[@"data"][@"source"];
        
        [lineView.shopButton setTitle:[NSString stringWithFormat:@"%@",dict[@"button_title"]] forState:UIControlStateNormal];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)taoBaoButton {
    NSLog(@"%@",self.taobaoUrl);
    GSPurchaseController *purchase = [[GSPurchaseController alloc] init];
    
    purchase.purchaseString = self.urlString;
//    [self presentViewController:purchase animated:YES completion:nil];
    
    [self.navigationController pushViewController:purchase animated:YES];
}

@end
