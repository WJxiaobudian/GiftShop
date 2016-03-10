//
//  GSFirst.h
//  GiftShop
//
//  Created by WJ on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSFirstModel;
@class GSCategoryModel;
@interface GSFirst : UIView

@property (nonatomic, strong) GSFirstModel *firstModel;

@property (nonatomic, strong) GSCategoryModel *categoryModel;

+ (instancetype)first;

@end
