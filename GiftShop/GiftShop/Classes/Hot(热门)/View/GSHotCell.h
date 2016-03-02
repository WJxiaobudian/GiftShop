//
//  GSHotCell.h
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSHotModel.h"
@interface GSHotCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoImage;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UILabel *favoriteLabel;

@property (nonatomic, strong) GSHotModel *model;
@end
