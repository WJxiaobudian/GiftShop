//
//  GSScroll.h
//  GiftShop
//
//  Created by WJ on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSScroll : NSObject


@property (nonatomic, copy) NSString *Nid;

@property (nonatomic, copy) NSString *image_url;

@property (nonatomic, copy) NSString *target_url;

@property (nonatomic, copy) NSString *webp_url;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *target_id;

@property (nonatomic, strong) NSDictionary *target;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)scrollWithDict:(NSDictionary *)dict;

@end
