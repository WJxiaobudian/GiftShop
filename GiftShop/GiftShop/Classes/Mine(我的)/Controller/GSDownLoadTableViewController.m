//
//  GSDownLoadTableViewController.m
//  GiftShop
//
//  Created by WJ on 16/3/9.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSDownLoadTableViewController.h"
#import "GSAPP.h"
#import "GSDownLoadCell.h"
@interface GSDownLoadTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GSDownLoadTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.tableView.backgroundColor = XMGGlobalBg;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GSDownLoadCell class]) bundle:nil] forCellReuseIdentifier:@"GSDownLoadCell"];
    
    [self loadData];
}

- (void)loadData {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[AFHTTPSessionManager manager] GET:@"http://api.liwushuo.com/v2/apps/ios" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = responseObject[@"data"][@"ios_apps"];
        for (NSDictionary *dict in array) {
            GSAPP *app = [[GSAPP alloc] initWithDict:dict];
            [self.dataArray addObject:app];
            
            [self.tableView reloadData];
            
        }
       
        [SVProgressHUD dismiss];
     
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSDownLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSDownLoadCell"];
    if (!cell) {
        cell = [[GSDownLoadCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GSDownLoadCell"];
    }
    
    GSAPP *app = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.app = app;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSAPP *app = self.dataArray[indexPath.row];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.download_url]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
    
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
