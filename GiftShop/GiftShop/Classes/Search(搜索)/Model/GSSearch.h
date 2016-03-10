//
//  GSSearch.h
//  GiftShop
//
//  Created by WJ on 16/3/5.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSSearch : NSObject

//@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *Nid;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *channels;

//@property (nonatomic, copy) NSString *order;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)searchWithDict:(NSDictionary *)dict;

@end
