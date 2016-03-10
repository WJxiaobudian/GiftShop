//
//  GSCategoryListModel.m
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryListModel.h"

@implementation GSCategoryListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"])  {
        self.Nid = value;
    }
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    GSCategoryListModel *model = [[GSCategoryListModel alloc] init];
    
    model.icon_url = dict[@"icon_url"];
    
    model.Nid = dict[@"id"];
    
    model.name = dict[@"name"];
    
    
    return model;
}
@end
