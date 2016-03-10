//
//  GSCategoryCell.m
//  GiftShop
//
//  Created by WJ on 16/3/5.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryCell.h"
#import "GSCategoryModel.h"
#import "GSFirst.h"

@interface GSCategoryCell ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GSCategoryCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.scrollView= [[UIScrollView alloc] init];
        self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 120);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}

- (void)setData:(NSMutableArray *)data {
    
    _data = data;
    
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = 180;
    CGFloat H = 100;
    
    for ( int i = 0; i < data.count; i ++) {
        GSFirst *firstView = [GSFirst first];
        X = i * W;
        firstView.frame = CGRectMake(X, Y, W, H);
        firstView.categoryModel = self.data[i];
        [self.scrollView addSubview:firstView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(X, Y, W, H);
        button.tag = i;
        [button addTarget:self action:@selector(firstViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        self.scrollView.bounces = YES;
    }
    self.scrollView.contentSize = CGSizeMake(data.count * W, 0);
}

- (void)firstViewClick:(UIButton *)button {
    
    if (_delegate && [_delegate respondsToSelector:@selector(firstCellClick:)]) {
        [_delegate firstCellClick:button];
    }
}


@end
