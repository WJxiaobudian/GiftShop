//
//  GSTabBarView.h
//  GiftShop
//
//  Created by WJ on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSTabBarView : UIView
@property (weak, nonatomic) IBOutlet UIButton *LoveButton;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
+ (instancetype)first;
@end
