//
//  GSFirstCollectionViewCell.m
//  GiftShop
//
//  Created by coder_xue on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSFirstCollectionViewCell.h"

@implementation GSFirstCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupItem];
    }
    return self;
}

- (void)setupItem {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 40)];
    
    [self.contentView addSubview:self.imageView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.contentView.bounds.size.width - 25, self.contentView.bounds.size.width , 40)];
    self.label.text = @"测试";
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label];
    
    
}

@end
