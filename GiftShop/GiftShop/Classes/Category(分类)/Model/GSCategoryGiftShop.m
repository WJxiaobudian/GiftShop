//
//  GSCategoryGiftShop.m
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryGiftShop.h"
#import "GSCategoryListModel.h"
#import "GSCategoryListModel.h"
@implementation GSCategoryGiftShop


- (instancetype)initWithDict:(NSDictionary *)dict {
    GSCategoryGiftShop *gift = [[GSCategoryGiftShop alloc] init];
    
    gift.name = dict[@"name"];
    
//    gift.subcategories = dict[@"subcategories"];
    
    NSArray *array = dict[@"subcategories"];
    NSMutableArray *data = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        GSCategoryListModel *model = [[GSCategoryListModel alloc] initWithDict:dic];
        [data addObject:model];
    }
    gift.subcategories = data;
    return gift;
}
@end
