//
//  GSScroll.m
//  GiftShop
//
//  Created by WJ on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSScroll.h"

@implementation GSScroll


- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        value = self.Nid;
    }
    [super setValue:value forKey:key];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    GSScroll * scroll = [[GSScroll alloc] init];
    
    scroll.Nid = dict[@"id"];
    
    scroll.image_url = dict[@"image_url"];
    
    scroll.target_url = dict[@"target_url"];
    
    scroll.webp_url = dict[@"webp_url"];
    scroll.url = [[scroll.webp_url componentsSeparatedByString:@"/"] objectAtIndex:4];
    
    scroll.target_id = dict[@"target_id"];
    scroll.title = dict[@"target"][@"title"];
    
    scroll.target = dict[@"target"];
    
    return scroll;
    
}

+ (instancetype)scrollWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
