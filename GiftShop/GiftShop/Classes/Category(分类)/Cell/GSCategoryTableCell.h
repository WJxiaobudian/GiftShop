//
//  GSCategoryTableCell.h
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSHead;
@class GSCollectionModel;

@protocol tapCollectionItemDelegate <NSObject>

- (void)tapCollection:(GSCollectionModel *)model;

@end
@interface GSCategoryTableCell : UITableViewCell

@property (nonatomic, strong) GSHead *head;


@property (nonatomic, strong) id<tapCollectionItemDelegate>delegate;

@end
