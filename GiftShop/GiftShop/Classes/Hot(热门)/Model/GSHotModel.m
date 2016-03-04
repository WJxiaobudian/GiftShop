//
//  GSHotModel.m
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSHotModel.h"

@implementation GSHotModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    GSHotModel *model = [[GSHotModel alloc] init];
    
    model.cover_image_url = dict[@"cover_image_url"];
    
    model.price = dict[@"price"];
    
    model.favorites_count = [dict[@"favorites_count"] integerValue];
    
    model.name = dict[@"name"];
    
    model.url = dict[@"url"];
    
    return model;
    
}

+ (instancetype)hotModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
