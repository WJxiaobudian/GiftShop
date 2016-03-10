//
//  GSHotCell.m
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSHotCell.h"

#import "GSHotModel.h"
@implementation GSHotCell

- (void)setModel:(GSHotModel *)model {
    
    
    self.priceLabel.text = model.price;
    self.titleLabel.text = model.name;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(3, 2, 30, 30)];
    image.image = [UIImage imageNamed:@"tabBar_me_icon"];
    [self.favoriteLabel addSubview:image];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%.1fk", model.favorites_count / 1000.0];
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
