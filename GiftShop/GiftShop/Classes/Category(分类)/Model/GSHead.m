//
//  GSHead.m
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSHead.h"
#import "GSCollectionModel.h"
@implementation GSHead

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Nid  = value;
    }
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    GSHead *head = [[GSHead alloc] init];
    
    head.Nid = dict[@"id"];
    
    head.name = dict[@"name"];
    
    head.order = dict[@"order"];
    
//    head.channels = dict[@"channels"];
    
    NSArray *channels = dict[@"channels"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in channels) {
        GSCollectionModel *model = [GSCollectionModel collectionWithDict:dict];
        [array addObject:model];
    }
    head.channels = array;
    
    return head;
    
}
@end
