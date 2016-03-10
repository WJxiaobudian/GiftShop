//
//  GSCategoryModel.m
//  GiftShop
//
//  Created by WJ on 16/3/5.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryModel.h"

@implementation GSCategoryModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Nid = value;
    }
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    GSCategoryModel *category = [[GSCategoryModel alloc] init];
    category.banner_image_url = dict[@"banner_image_url"];
    
    category.banner_webp_url = dict[@"banner_webp_url"];
    
    category.cover_image_url = dict[@"cover_image_url"];
    
    category.cover_webp_url = dict[@"cover_webp_url"];
    
    category.Nid = dict[@"id"];
    
    category.subtitle = dict[@"subtitle"];
    
    category.title = dict[@"title"];
    
    return category;
}
@end
