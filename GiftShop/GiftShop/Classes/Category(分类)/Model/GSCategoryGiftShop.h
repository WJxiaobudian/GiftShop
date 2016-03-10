//
//  GSCategoryGiftShop.h
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCategoryGiftShop : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *subcategories;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
