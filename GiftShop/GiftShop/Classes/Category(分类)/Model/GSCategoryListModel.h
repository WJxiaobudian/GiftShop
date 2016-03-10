//
//  GSCategoryListModel.h
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCategoryListModel : NSObject

@property (nonatomic, copy) NSString *icon_url;

@property (nonatomic, copy) NSString *Nid;

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
