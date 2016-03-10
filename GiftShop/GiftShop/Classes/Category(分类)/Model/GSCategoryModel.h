//
//  GSCategoryModel.h
//  GiftShop
//
//  Created by WJ on 16/3/5.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCategoryModel : NSObject

@property (nonatomic, copy) NSString *banner_image_url;

@property (nonatomic, copy) NSString *banner_webp_url;

@property (nonatomic, copy) NSString *cover_image_url;

@property (nonatomic, copy) NSString *cover_webp_url;

@property (nonatomic, copy) NSString *Nid;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
