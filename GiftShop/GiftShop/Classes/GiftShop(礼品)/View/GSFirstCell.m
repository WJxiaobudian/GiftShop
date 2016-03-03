//
//  GSFirstCell.m
//  GiftShop
//
//  Created by WJ on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSFirstCell.h"
#import "GSFirst.h"
@interface GSFirstCell ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GSFirstCell


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
    CGFloat W = 120;
    CGFloat H = 120;
    
    for ( int i = 1; i < data.count; i ++) {
        GSFirst *firstView = [GSFirst first];
        X = (i - 1) * W;
        firstView.frame = CGRectMake(X, Y, W, H);
        firstView.firstModel = self.data[i];
        [self.scrollView addSubview:firstView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(X, Y, W, H);
        button.tag = i;
        [button addTarget:self action:@selector(firstViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }
    self.scrollView.contentSize = CGSizeMake((data.count - 1 ) * W, 0);
}

- (void)firstViewClick:(UIButton *)button {
    
    if (_delegate && [_delegate respondsToSelector:@selector(firstCellClick:)]) {
        [_delegate firstCellClick:button];
    }
}
@end
