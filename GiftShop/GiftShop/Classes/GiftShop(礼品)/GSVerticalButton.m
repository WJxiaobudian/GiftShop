//
//  GSVerticalButton.m
//  GiftShop
//
//  Created by WJ on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSVerticalButton.h"

@implementation GSVerticalButton

- (void)awakeFromNib {
    [self setupView];
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.x = 5;
    self.imageView.y = 5;
    self.imageView.width = self.width - 15;
    self.imageView.height = self.imageView.height;
    
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height + 5;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    
}

@end
