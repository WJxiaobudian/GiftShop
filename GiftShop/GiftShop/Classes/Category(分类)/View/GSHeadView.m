//
//  GSHeadView.m
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSHeadView.h"

@implementation GSHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)head {
    return [[[NSBundle mainBundle] loadNibNamed:@"GSHeadView" owner:nil options:nil] lastObject];
}
@end
