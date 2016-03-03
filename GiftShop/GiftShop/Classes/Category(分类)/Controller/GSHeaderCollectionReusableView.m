//
//  GSHeaderCollectionReusableView.m
//  GiftShop
//
//  Created by coder_xue on 16/3/3.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSHeaderCollectionReusableView.h"

@implementation GSHeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
    }
    return self;
}

- (void)setupData {
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 30)];
//    self.label.backgroundColor = [UIColor yellowColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
}
@end
