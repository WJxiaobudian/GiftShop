//
//  GSSearchList.m
//  GiftShop
//
//  Created by WJ on 16/3/7.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSSearchList.h"

@implementation GSSearchList

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Nid = value;
    }
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    GSSearchList *list = [[GSSearchList alloc] init];
    
    list.group_id = dict[@"group_id"];
    
    list.Nid = dict[@"id"];
    
    list.name = dict[@"name"];
    
    list.key = dict[@"key"];
    
    return list;
}
@end
