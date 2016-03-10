//
//  GSCategoryTableCell.m
//  GiftShop
//
//  Created by WJ on 16/3/6.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryTableCell.h"
#import "GSCategoryCollectionCell.h"
#import "GSHead.h"
#import "GSCollectionModel.h"
@interface GSCategoryTableCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *datasArray;


@end
@implementation GSCategoryTableCell

- (NSArray *)datasArray {
    if (!_datasArray) {
        _datasArray = [NSArray array];
    }
    return _datasArray;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        CGFloat W = (ScreenWidth - 50)/4;
        CGFloat H = W + 30;
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



- (void)setHead:(GSHead *)head {
    
    _head = head;
    self.datasArray = head.channels;

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
 

    return category;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GSCollectionModel *model = self.datasArray[indexPath.item];
    if (_delegate &&[_delegate respondsToSelector:@selector(tapCollection:)]) {
        [_delegate tapCollection:model];
    }
}


@end
