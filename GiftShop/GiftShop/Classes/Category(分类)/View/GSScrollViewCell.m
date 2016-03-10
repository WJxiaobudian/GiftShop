//
//  GSScrollViewCell.m
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSScrollViewCell.h"
#import "GSGiftShop.h"

@interface GSScrollViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverWebUrlImge;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabe;

@end
@implementation GSScrollViewCell

- (void)setGiftShop:(GSGiftShop *)giftShop {
    
    [self.coverWebUrlImge sd_setImageWithURL:[NSURL URLWithString:giftShop.cover_image_url]];
    
    self.titleLabel.text = giftShop.title;
    
    self.subtitleLabe.text = giftShop.subtitle;
    
}

//- (void)setFrame:(CGRect)frame {
////    self.coverWebUrlImge.layer.masksToBounds = YES;
//    
////    self.coverWebUrlImge.layer.cornerRadius = 10;
//    
//}
@end
