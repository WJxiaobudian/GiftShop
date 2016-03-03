//
//  GSCollectionViewCell.h
//  GiftShop
//
//  Created by coder_xue on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSGiftModel.h"
@interface GSCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *ItemLabel;
@property (nonatomic,strong)GSGiftModel *model;


@end
