//
//  GSHeader.m
//  GiftShop
//
//  Created by WJ on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSHeader.h"

@implementation GSHeader

+ (instancetype)headView {
    return [[[NSBundle mainBundle] loadNibNamed:@"GSHeader" owner:nil options:nil] lastObject];
}


@end
