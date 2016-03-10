//
//  GSMineController.m
//  GiftShop
//
//  Created by WJ on 16/2/29.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSMineController.h"
#import "GSAPP.h"
#import "WdCleanCaches.h"
#import "GSAboutOurController.h"
#import "GSstatementController.h"
#import "GSDownLoadTableViewController.h"
@interface GSMineController ()

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;


@end

@implementation GSMineController

- (void)viewWillAppear:(BOOL)animated {
    
    self.cacheLabel.text = [NSString stringWithFormat:@"%.1f MB",[WdCleanCaches folderSizeAtPath:[WdCleanCaches LibraryDirectory]]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];



}

- (IBAction)aboutOur:(UIButton *)sender {
    GSAboutOurController *about = [[GSAboutOurController alloc] init];
    
    [self.navigationController pushViewController:about animated:YES];
}

- (IBAction)statement:(UIButton *)sender {
    
    GSstatementController *statement = [[GSstatementController alloc] init];
    
    [self.navigationController pushViewController:statement animated:YES];
}

- (IBAction)APPlist:(UIButton *)sender {
    
    GSDownLoadTableViewController *down = [[GSDownLoadTableViewController alloc] init];
    
    [self.navigationController pushViewController:down animated:YES];
}


- (IBAction)clearButton:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否清理缓存？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }];
    
    UIAlertAction *defau = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [WdCleanCaches clearCache:[WdCleanCaches LibraryDirectory]];
        self.cacheLabel.text = [NSString stringWithFormat:@"Zero KB"];
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:defau];
    [self presentViewController:alert animated:YES completion:nil];
    
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
