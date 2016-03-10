//
//  GSCategoryRightCell.h
//  GiftShop
//
//  Created by WJ on 16/3/7.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSCategoryGiftShop;
@class GSCollectionModel;

@protocol tapCollectionDelegate <NSObject>

- (void)tapRightCollection:(GSCollectionModel *)model;

@end

@interface GSCategoryRightCell : UITableViewCell

@property (nonatomic, strong) GSCategoryGiftShop *giftShop;


@property (nonatomic, strong) id<tapCollectionDelegate>delegate;

@end
