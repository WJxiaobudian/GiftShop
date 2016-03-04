//
//  GSTabBarController.m
//  GiftShop
//
//  Created by WJ on 16/2/29.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSTabBarController.h"
#import "GSGiftShopViewController.h"
#import "GSHotController.h"
#import "GSCategoryController.h"
#import "GSMineController.h"
#import "GSNavViewController.h"
@interface GSTabBarController ()

@end

@implementation GSTabBarController

+ (void)initialize {
    
    UITabBar *tabBar = [UITabBar appearance];
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupChild];
}


- (void)setupChild {
    
    GSGiftShopViewController *giftShop = [[GSGiftShopViewController alloc] init];
    [self setupController:giftShop title:@"礼品屋" stateImage:@"tabBar_essence_icon" highImage:@"tabBar_essence_click_icon"];
    
    GSHotController *hot = [[GSHotController alloc] init];
    [self setupController:hot title:@"热门" stateImage:@"tabBar_new_icon" highImage:@"tabBar_new_click_icon"];
    
    GSCategoryController *category = [[GSCategoryController alloc] init];
    [self setupController:category title:@"分类" stateImage:@"tabBar_me_icon" highImage:@"tabBar_me_click_icon"];
    
    GSMineController *mine = [[GSMineController alloc] init];
    [self setupController:mine title:@"我的" stateImage:@"tabBar_friendTrends_icon" highImage:@"tabBar_friendTrends_click_icon"];
    
}

- (void)setupController:(UIViewController *)vc title:(NSString *)title stateImage:(NSString *)image highImage:(NSString *)highImage {
    
    GSNavViewController *nav = [[GSNavViewController alloc] initWithRootViewController:vc];
    
    vc.title = title;
    
    vc.tabBarItem.image = [UIImage imageNamed:image];
    
    vc.tabBarItem.selectedImage = [UIImage imageNamed:highImage];
    vc.view.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
    
    [self addChildViewController:nav];
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
