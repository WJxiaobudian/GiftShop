//
//  GSGiftShop.h
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSGiftShop : NSObject

@property (nonatomic, copy) NSString *cover_image_url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger likes_count;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *content_url;

@property (nonatomic, copy) NSString *cover_webp_url;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *NumString;

@property (nonatomic, copy) NSString *userId;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)giftShopWithDict:(NSDictionary *)dict;

@end
