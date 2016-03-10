//
//  GSDownLoadCell.m
//  GiftShop
//
//  Created by WJ on 16/3/9.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSDownLoadCell.h"
#import "GSAPP.h"
@interface GSDownLoadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

@end
@implementation GSDownLoadCell

- (void)setApp:(GSAPP *)app {
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:app.icon_url]];
    
    self.titleLabel.text = app.title;
    
    self.subTitleLabel.text = app.subtitle;
    
        self.downButton.layer.borderColor = [UIColor redColor].CGColor;
        self.downButton.layer.borderWidth = 1;
}

//- (void)setFrame:(CGRect)frame {
//    
//    self.downButton.layer.borderColor = [UIColor redColor].CGColor;
//    self.downButton.layer.borderWidth = 1;
//    
//}
@end
