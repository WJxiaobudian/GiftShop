//
//  GSGiftShop.m
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSGiftShop.h"
#import "GSExtenssion.h"
@implementation GSGiftShop

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"]){
        self.userId = value;
    }
//    [super setValue:value forUndefinedKey:key];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    GSGiftShop *giftShop = [[GSGiftShop alloc] init];
    
    giftShop.title = dict[@"title"];
    
    giftShop.likes_count = [dict[@"likes_count"] integerValue];
    
    giftShop.cover_image_url = dict[@"cover_image_url"] ;
    
    giftShop.url = dict[@"url"];
    
    giftShop.userId = dict[@"id"];
    
    giftShop.content_url = dict[@"content_url"];
    
    giftShop.subtitle = dict[@"subtitle"];
    
    NSString *str=dict[@"created_at"];//时间戳
    NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd";
    
    NSString *weekDay = [GSExtenssion getWeekDayFordate:time];
    
    giftShop.created_at = [NSString stringWithFormat:@"%@  %@",[formatter stringFromDate:detaildate], weekDay];
    
    giftShop.cover_webp_url = dict[@"cover_webp_url"];
    
    giftShop.NumString = [[dict[@"url"] componentsSeparatedByString:@"/"] lastObject];
    
    return giftShop;
}

+ (instancetype)giftShopWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
    
}
@end
