//
//  GSTaobao.m
//  GiftShop
//
//  Created by WJ on 16/3/4.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSTaobao.h"

@implementation GSTaobao


- (instancetype)initWithDict:(NSDictionary *)dict {
    GSTaobao *taoBao = [[GSTaobao alloc] init];
    taoBao.image_urls = dict[@"image_urls"];
    
    taoBao.url = dict[@"url"];
    
    taoBao.detail_html = dict[@"detail_html"];
    
    taoBao.Tdescription = dict[@"description"];
    taoBao.name = dict[@"name"];
    taoBao.price = dict[@"price"];
    taoBao.cover_webp_url = dict[@"cover_webp_url"];
    taoBao.source = dict[@"source"];
    taoBao.button_title = taoBao.source[@"button_title"];
    taoBao.image_urls = dict[@"image_urls"];
    taoBao.purchase_url = dict[@"purchase_url"];
    
    return taoBao;
}

+ (instancetype)taoBaoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
