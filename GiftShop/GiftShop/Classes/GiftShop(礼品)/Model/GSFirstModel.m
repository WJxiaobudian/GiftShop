//
//  GSFirstModel.m
//  GiftShop
//
//  Created by WJ on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSFirstModel.h"

@implementation GSFirstModel

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        value = self.Nid;
    }
    [super setValue:value forKey:key];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    GSFirstModel * firstModel = [[GSFirstModel alloc] init];
    
    firstModel.Nid = dict[@"id"];
    
    firstModel.image_url = dict[@"image_url"];
    
    firstModel.target_url = dict[@"target_url"];
    
    firstModel.webp_url = dict[@"webp_url"];
    
    firstModel.url = [[firstModel.target_url componentsSeparatedByString:@"="] lastObject];
    NSArray *array = [firstModel.target_url componentsSeparatedByString:@"&"];
    
    firstModel.urlString = [[[array objectAtIndex:1] componentsSeparatedByString:@"="] lastObject];
    
    return firstModel;
}

+ (instancetype)scrollWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
