//
//  GSFirst.m
//  GiftShop
//
//  Created by WJ on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSFirst.h"
#import "UIImageView+WebCache.h"
#import "GSFirstModel.h"
@interface GSFirst ()
@property (weak, nonatomic) IBOutlet UIImageView *PhotoImage;

@end

@implementation GSFirst

- (void)setFirstModel:(GSFirstModel *)firstModel {
    _firstModel = firstModel;
    
    [self.PhotoImage sd_setImageWithURL:[NSURL URLWithString:firstModel.image_url]];
}


+ (instancetype)first {
    return [[[NSBundle mainBundle] loadNibNamed:@"GSFirst" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    self.PhotoImage.layer.masksToBounds = YES;
    self.PhotoImage.layer.cornerRadius = 20;
}
@end
