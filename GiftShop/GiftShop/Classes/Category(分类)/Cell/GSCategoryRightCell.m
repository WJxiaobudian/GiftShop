//
//  GSCategoryRightCell.m
//  GiftShop
//
//  Created by WJ on 16/3/7.
//  Copyright © 2016年 WJ. All rights reserved.
//


#import "GSCategoryRightCell.h"
#import "GSCategoryCollectionCell.h"
#import "GSCategoryGiftShop.h"
#import "GSCollectionModel.h"
@interface GSCategoryRightCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *datasArray;


@end
@implementation GSCategoryRightCell

- (NSArray *)datasArray {
    if (!_datasArray) {
        _datasArray = [NSArray array];
    }
    return _datasArray;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        CGFloat W = (ScreenWidth - 100 - 40)/3;
        CGFloat H = W + 20;
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flow.itemSize = CGSizeMake(W, H);
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.contentView addSubview:self.collectionView];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.bounces = NO;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"GSCategoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GSCategoryCollectionCell"];
    }
    return self;
}



- (void)setGiftShop:(GSCategoryGiftShop *)giftShop {
    
    _giftShop = giftShop;
    self.datasArray = giftShop.subcategories;
    
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSCategoryCollectionCell *category = [collectionView dequeueReusableCellWithReuseIdentifier:@"GSCategoryCollectionCell" forIndexPath:indexPath];
    
    category.collectionModel =self.datasArray[indexPath.item];
    category.nameLabel.font = [UIFont systemFontOfSize:12];
  
    return category;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GSCollectionModel *model = self.datasArray[indexPath.item];
    if (_delegate &&[_delegate respondsToSelector:@selector(tapRightCollection:)]) {
        [_delegate tapRightCollection:model];
    }
}
@end