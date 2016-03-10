//
//  GSCategoryCollectionCell.h
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSCollectionModel;
@interface GSCategoryCollectionCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) GSCollectionModel *collectionModel;
@end
