//
//  GSCollectionViewCell.m
//  GiftShop
//
//  Created by coder_xue on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation GSCollectionViewCell

- (void)setModel:(GSGiftModel *)model {
    
    self.ItemLabel.text = model.name;
    [self.itemImage sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
