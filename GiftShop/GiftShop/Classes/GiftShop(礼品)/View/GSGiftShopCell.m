//
//  GSGiftShopCell.m
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSGiftShopCell.h"
#import "GSGiftShop.h"

@interface GSGiftShopCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *likesCount;


@property (weak, nonatomic) IBOutlet UIImageView *contentUrl;
@property (weak, nonatomic) IBOutlet UILabel *Label;

@end


@implementation GSGiftShopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setGiftShop:(GSGiftShop *)giftShop {
    
    _giftShop = giftShop;
    
    self.titleLabel.text = giftShop.title;
    self.likesCount.text = [NSString stringWithFormat:@"%ld",giftShop.likes_count];
    [self.contentUrl sd_setImageWithURL:[NSURL URLWithString:giftShop.cover_image_url] placeholderImage:nil];
}

- (void)setFrame:(CGRect)frame {
    
    self.Label.layer.masksToBounds = YES;
    self.Label.layer.cornerRadius = 15;
    
    
    CGFloat margin = 10;
    
    frame.origin.x = 10;
    frame.size.width -= 2 * margin;
    frame.size.height -= margin;
    frame.origin.y += 10;

    
    [super setFrame:frame];
}
@end
