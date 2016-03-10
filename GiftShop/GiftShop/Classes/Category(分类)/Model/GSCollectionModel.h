//
//  GSCollectionModel.h
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCollectionModel : NSObject

//@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *icon_url;

@property (nonatomic, copy) NSString *Nid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *items_count;

- (instancetype) initWithDict:(NSDictionary *)dict;

+ (instancetype) collectionWithDict:(NSDictionary *)dict;

@end
