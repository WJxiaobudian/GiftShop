//
//  GSAPP.h
//  GiftShop
//
//  Created by WJ on 16/3/9.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSAPP : NSObject

@property (nonatomic, copy) NSString *download_url;

@property (nonatomic, copy) NSString *icon_url;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *title;

- (instancetype) initWithDict:(NSDictionary *)dict;


@end
