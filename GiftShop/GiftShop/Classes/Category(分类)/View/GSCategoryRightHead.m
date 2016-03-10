//
//  GSCategoryRightHead.m
//  GiftShop
//
//  Created by WJ on 16/3/7.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryRightHead.h"



@implementation GSCategoryRightHead

+ (instancetype)head {
    return [[[NSBundle mainBundle] loadNibNamed:@"GSCategoryRightHead" owner:nil options:nil] lastObject];
}
@end
