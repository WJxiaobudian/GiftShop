//
//  GSHeadView.m
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryCollectionCell.h"
#import "GSCollectionModel.h"

@interface GSCategoryCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconUrlImageView;


@end
@implementation GSCategoryCollectionCell

- (void)setCollectionModel:(GSCollectionModel *)collectionModel {
    
    self.nameLabel.text = collectionModel.name;
    
    [self.iconUrlImageView sd_setImageWithURL:[NSURL URLWithString:collectionModel.icon_url]];
    
}
@end
