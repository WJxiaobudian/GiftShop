//
//  GSTailTableCell.m
//  GiftShop
//
//  Created by WJ on 16/3/8.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSTailTableCell.h"
#import "GSGiftShop.h"
@interface GSTailTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *PhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation GSTailTableCell

- (void)setGiftShop:(GSGiftShop *)giftShop {
    
    [self.PhotoImageView sd_setImageWithURL:[NSURL URLWithString:giftShop.cover_image_url]];
    
    self.titleLabel.text = giftShop.title;
}
@end
