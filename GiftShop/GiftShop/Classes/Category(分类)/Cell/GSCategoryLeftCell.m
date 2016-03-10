//
//  GSCategoryLeftCell.m
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryLeftCell.h"
#import "GSCategoryGiftShop.h"
@interface GSCategoryLeftCell ()

@property (weak, nonatomic) IBOutlet UIView *LeftView;


@end
@implementation GSCategoryLeftCell


- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = XMGRGBColor(244, 244, 244);
    self.LeftView.backgroundColor = XMGRGBColor(219, 21, 26);
}
- (void)setGiftShop:(GSCategoryGiftShop *)giftShop {
 

    
    self.textLabel.text = giftShop.name;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.LeftView.hidden = !selected;
    self.textLabel.textColor = selected ?self.LeftView.backgroundColor : XMGRGBColor(78, 78, 78);

    self.backgroundColor = selected ?[UIColor whiteColor] :XMGRGBColor(244, 244, 244);
    // Configure the view for the selected state
}

@end
