//
//  GSCollectionModel.m
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCollectionModel.h"

@implementation GSCollectionModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Nid = value;
    }
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    GSCollectionModel *model = [[GSCollectionModel alloc] init];
    
    model.icon_url = dict[@"icon_url"];
    
    model.Nid = dict[@"id"];
    
    model.items_count = dict[@"items_count"];
    
    model.name = dict[@"name"];
    
    return model;
}

+ (instancetype)collectionWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
