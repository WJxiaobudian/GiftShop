//
//  GSStrategyHeaderCollectionReusableView.m
//  GiftShop
//
//  Created by coder_xue on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSStrategyHeaderCollectionReusableView.h"

@implementation GSStrategyHeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
    }
    return self;
}

- (void)setupData {
    self.HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.frame.size.width, 50)];

    self.HeaderLabel.textColor = [UIColor blackColor];
    self.HeaderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.HeaderLabel];
}
@end
