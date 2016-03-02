//
//  GSHotModel.h
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GSHotModel : NSObject
// 图片
@property (nonatomic, copy) NSString *cover_image_url;
// 礼物价钱
@property (nonatomic, copy) NSString *price;
// 喜欢的人数
@property (nonatomic, assign) NSInteger favorites_count;
// 礼物名字
@property (nonatomic, copy) NSString *name;
// 详情页面
@property (nonatomic, copy) NSString *url;
@end
