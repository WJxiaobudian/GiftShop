//
//  GSButton.m
//  GiftShop
//
//  Created by WJ on 16/3/5.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSButton.h"

@implementation GSButton


+ (instancetype)button {
    return [[[NSBundle mainBundle] loadNibNamed:@"GSButton" owner:nil options:nil] lastObject];
}



@end
