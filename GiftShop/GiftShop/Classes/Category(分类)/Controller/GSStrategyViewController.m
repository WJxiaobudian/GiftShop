//
//  GSStrategyViewController.m
//  GiftShop
//
//  Created by coder_xue on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSStrategyViewController.h"
#import "PrefixHeader.pch"
#import "GSCategoryManager.h"
#import "UIImageView+WebCache.h"
#import "GSCategoryModel.h"
#import "PrefixHeader.pch"
#import "GSFirstCollectionViewCell.h"
#import "GSFirrstModel.h"
#import "GSStrategyHeaderCollectionReusableView.h"
#define interval 20

#define IMAGEURL @"http://api.liwushuo.com/v2/collections?limit=6&offset=0"
#define FIRSTURL @"http://api.liwushuo.com/v2/channel_groups/all"
@interface GSStrategyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//@property (nonatomic,strong)NSMutableArray *
@property (weak, nonatomic) IBOutlet UICollectionView *firstCollection;


@property (weak, nonatomic) IBOutlet UIView *contantView;
@end

@implementation GSStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstCollection.delegate = self;
    self.firstCollection.dataSource = self;

    [self makeCollection];
    
    [self sliderImage];
    
    [self registerCell];
    
    [[GSCategoryManager shardInstance]requestCategoryWithUrl:FIRSTURL finish:^{
        [self.firstCollection reloadData];
    }];
    
        // Do any additional setup after loading the view from its nib.
}
- (void)makeCollection {
    
    
    UICollectionViewFlowLayout *firstLayout = [[UICollectionViewFlowLayout alloc] init];
    firstLayout.itemSize = CGSizeMake((self.firstCollection.bounds.size.width  - 50) / 4, (self.firstCollection.bounds.size.width - 50)/ 4);
    firstLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    firstLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    firstLayout.minimumInteritemSpacing = 10;
    firstLayout.minimumLineSpacing = 10;
    firstLayout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
    firstLayout.headerReferenceSize = CGSizeMake(320, 50);

    self.firstCollection.collectionViewLayout = firstLayout;
    
    
}
- (void)registerCell {
    
    [self.firstCollection registerClass:[GSFirstCollectionViewCell class] forCellWithReuseIdentifier:@"firstCell"];
    [self.firstCollection registerClass:[GSStrategyHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusablleView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        GSStrategyHeaderCollectionReusableView *headerView = (GSStrategyHeaderCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
              headerView.HeaderLabel.text =  [GSCategoryManager shardInstance].firstHeadArr[indexPath.section];
                break;
            case 1:
                headerView.HeaderLabel.text =  [GSCategoryManager shardInstance].firstHeadArr[indexPath.section];
                break;
            case 2:
                headerView.HeaderLabel.text =  [GSCategoryManager shardInstance].firstHeadArr[indexPath.section];
                break;
            case 3:
                headerView.HeaderLabel.text =  [GSCategoryManager shardInstance].firstHeadArr[indexPath.section];
                break;

            default:
                break;
        }
        
        
        reusablleView = headerView;
    }
    
    
    return reusablleView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    switch (section) {
        case 0:
           return  [(NSMutableArray *)[GSCategoryManager shardInstance].dicA[@"品类"] count];
        
        case 1:
            return  [(NSMutableArray *)[GSCategoryManager shardInstance].dicA[@"对象"] count];
        case 2:
            return  [(NSMutableArray *)[GSCategoryManager shardInstance].dicA[@"场合"] count];

        case 3:
            return  [(NSMutableArray *)[GSCategoryManager shardInstance].dicA[@"风格"] count];

        default:
            
            break;
            
            
            
    }
    
    return 0;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstCell" forIndexPath:indexPath];
    
    
    switch (indexPath.section) {
        case 0: {
            NSMutableArray *arr = [GSCategoryManager shardInstance].dicA[@"品类"];
            GSFirrstModel *model = arr[indexPath.row];
            cell.label.text = model.name;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];

            break;
        }
        case 1: {
            NSMutableArray *arr = [GSCategoryManager shardInstance].dicA[@"对象"];
            GSFirrstModel *model = arr[indexPath.row];
            cell.label.text = model.name;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
            break;
        }
        case 2: {
            NSMutableArray *arr = [GSCategoryManager shardInstance].dicA[@"场合"];
            GSFirrstModel *model = arr[indexPath.row];
            cell.label.text = model.name;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
            break;

        }
        case 3: {
            NSMutableArray *arr = [GSCategoryManager shardInstance].dicA[@"风格"];
            GSFirrstModel *model = arr[indexPath.row];
            cell.label.text = model.name;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
            break;

        }
            
        default:
            break;
    }
    
    return cell;
    

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld",(long)indexPath.row);
}

// 滑动图片加载
- (void)sliderImage {
    
    
    [[GSCategoryManager shardInstance] requestWithUrl:IMAGEURL finish:^{
        CGFloat imageW = (self.contantView.width - interval * 5)/ 6;
        CGFloat imageH = self.contantView.height;
        
        
        for (int i = 0; i < 6; i++) {
            UIImageView *image = [[UIImageView alloc] init];
            image.userInteractionEnabled = YES;
            image.frame = CGRectMake((imageW + interval)* i, 5, imageW, imageH);
            image.backgroundColor = [UIColor orangeColor];
            GSCategoryModel *model = [[GSCategoryManager shardInstance] modelWithIndex:i];
            [image sd_setImageWithURL:[NSURL URLWithString:model.banner_image_url]];
            //        btn setBackgroundImage:
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [image addGestureRecognizer:tap];
            [self.contantView addSubview:image];
        }
        
        
    }];

}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    NSLog(@"点位了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
