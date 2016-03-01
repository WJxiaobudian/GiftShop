//
//  GSGiftShop.m
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSGiftShop.h"

@implementation GSGiftShop


- (instancetype)initWithDict:(NSDictionary *)dict {
    
    GSGiftShop *giftShop = [[GSGiftShop alloc] init];
    
    giftShop.title = dict[@"title"];
    
    giftShop.likes_count = dict[@""];
    
    giftShop.cover_image_url = dict[@"cover_image_url"];
    
    giftShop.url = dict[@"url"];
    
    giftShop.content_url = dict[@"content_url"];
    
    giftShop.created_at = dict[@"created_at"];
    
    giftShop.cover_webp_url = dict[@"cover_webp_url"];
    
    return giftShop;
}

+ (instancetype)giftShopWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
    
}
@end
