//
//  GSHead.h
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSHead : NSObject

@property (nonatomic, copy) NSString *Nid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, strong) NSArray *channels;

- (instancetype) initWithDict:(NSDictionary *)dict;

@end
