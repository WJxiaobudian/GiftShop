//
//  GSHotView.m
//  GiftShop
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSHotView.h"

@implementation GSHotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置内一个元素的大小
    layout.itemSize = CGSizeMake(self.frame.size.width/2 - 20, self.frame.size.width/2 + 70);
    // 设置内边距的大小
    layout.sectionInset = UIEdgeInsetsMake(10, 12, 10, 12);
       
    self.listCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight + 44) collectionViewLayout:layout];
    [self addSubview:self.listCollectionView];
    
    self.listCollectionView.backgroundColor = [UIColor whiteColor];
    
}


@end
