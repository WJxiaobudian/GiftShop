//
//  GSSearchButton.m
//  GiftShop
//
//  Created by WJ on 16/3/7.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSSearchButton.h"

@implementation GSSearchButton


+ (instancetype)button {
    return [[[NSBundle mainBundle] loadNibNamed:@"GSSearchButton" owner:nil options:nil] lastObject];
}


@end
