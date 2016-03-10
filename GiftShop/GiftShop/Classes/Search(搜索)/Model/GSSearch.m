//
//  GSSearch.m
//  GiftShop
//
//  Created by WJ on 16/3/5.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSSearch.h"
#import "GSSearchList.h"
@implementation GSSearch

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Nid = value;
    }
}


- (instancetype)initWithDict:(NSDictionary *)dict {
    GSSearch *search = [[GSSearch alloc] init];
    
//    search.group_id = dict[@"group_id"];
    
    search.Nid = dict[@"id"];
    
    search.key = dict[@"key"];
    
    search.name = dict[@"name"];
    
    NSArray *array = dict[@"channels"];
    NSMutableArray *Marray = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        GSSearchList *list = [[GSSearchList alloc] initWithDict:dict];
        [Marray addObject:list];
    }
    search.channels = Marray;
//    search.order = dict[@"order"];
    
    return search;
}

+ (instancetype)searchWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
