//
//  GSSearchList.h
//  GiftShop
//
//  Created by WJ on 16/3/7.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSSearchList : NSObject

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *Nid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *key;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
