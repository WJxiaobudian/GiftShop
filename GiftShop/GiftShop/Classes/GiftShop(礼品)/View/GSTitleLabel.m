//
//  GSTitleLabel.m
//  GiftShop
//
//  Created by WJ on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSTitleLabel.h"

@implementation GSTitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];
        self.scale = 0.0;
        
    }
    return self;
}

- (void)setScale:(CGFloat)scale {
    
    _scale = scale;
    self.textColor = [UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:0.8];
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1 - minScale) *scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
    
}
@end
