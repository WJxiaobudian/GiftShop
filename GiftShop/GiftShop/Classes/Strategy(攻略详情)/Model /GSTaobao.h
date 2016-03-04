//
//  GSTaobao.h
//  GiftShop
//
//  Created by WJ on 16/3/4.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSTaobao : NSObject

@property (nonatomic, copy) NSString *button_title;

@property (nonatomic, copy) NSString *Tdescription;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *detail_html;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *cover_webp_url;

@property (nonatomic, strong) NSDictionary *source;

@property (nonatomic, strong) NSArray *image_urls;

@property (nonatomic, copy) NSString *purchase_url;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)taoBaoWithDict:(NSDictionary *)dict;



@end
