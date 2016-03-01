//
//  GSCategoryController.m
//  GiftShop
//
//  Created by WJ on 16/2/29.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryController.h"
#import "UIView+GSExtenssion.h"

#define intervil  124

@interface GSCategoryController ()

@property (nonatomic,strong)UISegmentedControl *segment;
@end

@implementation GSCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"dsasad");
//    CGFloat intervel = 124;
//
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"攻略",@"礼物"]];
    self.segment.frame = CGRectMake(0, 20,self.view.frame.size.width - intervil *2,30);
    self.segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView  = self.segment;
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
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
