//
//  GSExtenssion.h
//  GiftShop
//
//  Created by WJ on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSExtenssion : NSDate

+ (NSString *)getWeekDayFordate:(long long)data;

+ (NSString *)getDateAccordingTime:(NSString *)aTime formatStyle:(NSString *)formate;

@end
