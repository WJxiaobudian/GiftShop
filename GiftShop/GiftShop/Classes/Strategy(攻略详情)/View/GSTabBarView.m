//
//  GSTabBarView.m
//  GiftShop
//
//  Created by WJ on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSTabBarView.h"

@implementation GSTabBarView
+ (instancetype)first {
    return [[[NSBundle mainBundle] loadNibNamed:@"GSTabBarView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    self.LoveButton.layer.masksToBounds = YES;
    self.LoveButton.layer.cornerRadius = 20;
    
    self.shopButton.layer.masksToBounds = YES;
    self.shopButton.layer.cornerRadius = 20;
}
@end
