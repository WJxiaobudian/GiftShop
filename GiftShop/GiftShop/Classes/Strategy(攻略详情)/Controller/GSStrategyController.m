//
//  GSStrategyController.m
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSStrategyController.h"
#import "GSTaoBaoController.h"
#import "GSGiftShop.h"
#import "GSTailTableCell.h"
@interface GSStrategyController ()<UIScrollViewDelegate, UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UITableView *tabelView;

@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *numArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GSStrategyController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"攻略详情";
    
    self.view.backgroundColor = XMGGlobalBg;
    [self setupWebView];
    
   [self loadData];
    
    
}

- (void)loadData {
    
    NSString *num = [[self.urlString componentsSeparatedByString:@"/"] lastObject];
    
    NSString *string = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/posts/%@/recommend", num];
    
    [[AFHTTPSessionManager manager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
        NSArray *array = responseObject[@"data"][@"recommend_posts"];
        for (NSDictionary *dict in array) {
            GSGiftShop *giftShop = [[GSGiftShop alloc] initWithDict:dict];
            [self.dataArray addObject:giftShop];
            
        }
        if (self.dataArray != nil && ![self.dataArray isKindOfClass:[NSNull class]] && self.dataArray.count != 0) {
            [self.tabelView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)setupWebView {
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
#pragma mark --- webView

    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.webView = webView;
    webView.opaque = NO;
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self.view addSubview:self.webView];
    
#pragma mark --- ScrollView imageView
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.contentInset = UIEdgeInsetsMake(150 + 64, 0, 500, 0);
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

    [SVProgressHUD showProgress:0.5 status:@"正在加载"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    self.numArray = [NSMutableArray array];
    [[AFHTTPSessionManager manager] GET:self.urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        self.numArray = dict[@"item_ad_monitors"];

        [self.webView loadHTMLString:dict[@"content_html"] baseURL:nil];
        [self.image sd_setImageWithURL:[NSURL URLWithString:dict[@"cover_image_url"]]];
        label.text = self.titleLabel;
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载错误"];
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
  
        NSString *hasUrl = [NSString stringWithFormat:@"%@",url];
        
        NSString *string;
        if ([hasUrl hasPrefix:@"liwushuo"]) {
            
            string = [[hasUrl componentsSeparatedByString:@"="] lastObject];
        } else {
            
            string = [[[NSString stringWithFormat:@"%@",url] componentsSeparatedByString:@"/"]lastObject];
        }
        
        taoBao.urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/items/%@",string];
        [self.navigationController pushViewController:taoBao animated:YES];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

   
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, height + 35, ScreenWidth, 400) style:UITableViewStylePlain];
    
    self.tabelView = tabelView;
    
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    tabelView.backgroundColor = [UIColor blueColor];
    
    [self.tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([GSTailTableCell class]) bundle:nil] forCellReuseIdentifier:@"GSTailTableCell"];
    
    [self.webView.scrollView addSubview:tabelView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, height + 5, ScreenWidth - 20, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"—————— 你可能也喜欢 ——————";
    [self.webView.scrollView addSubview:label];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSTailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSTailTableCell"];
    if (!cell) {
        cell = [[GSTailTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GSTailTableCell"];
    }
    if (self.dataArray != nil && ![self.dataArray isKindOfClass:[NSNull class]] && self.dataArray.count != 0) {
        
        GSGiftShop *gift = self.dataArray[indexPath.row];
        cell.giftShop = gift;
    }    
    return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSStrategyController *text = [[GSStrategyController alloc] init];
    GSGiftShop *gift = self.dataArray[indexPath.row];
    text.urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/posts/%@",gift.userId];
    [self.navigationController pushViewController:text animated:YES];
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
