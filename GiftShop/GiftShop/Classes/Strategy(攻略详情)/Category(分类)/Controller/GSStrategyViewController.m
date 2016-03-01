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
#define interval 20
@interface GSStrategyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//@property (nonatomic,strong)NSMutableArray *
@property (weak, nonatomic) IBOutlet UICollectionView *firstCollection;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UIView *contantView;
@end

@implementation GSStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeCollection];
    
    [self sliderImage];
    
    [self registerCell];
    
    [[GSCategoryManager shardInstance]requestCategoryWithUrl:FIRSTURL finish:^{
        
    }];
    
        // Do any additional setup after loading the view from its nib.
}
- (void)makeCollection {
    
    self.firstCollection.delegate = self;
    self.firstCollection.dataSource = self;
    
    UICollectionViewFlowLayout *firstLayout = [[UICollectionViewFlowLayout alloc] init];
    firstLayout.itemSize = CGSizeMake((self.firstCollection.bounds.size.width  - 50) / 4, (self.firstCollection.bounds.size.width - 50)/ 4);
    firstLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    firstLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    firstLayout.minimumInteritemSpacing = 10;
    firstLayout.minimumLineSpacing = 10;
    self.firstCollection.collectionViewLayout = firstLayout;
    
    
}
- (void)registerCell {
    
    [self.firstCollection registerClass:[GSFirstCollectionViewCell class] forCellWithReuseIdentifier:@"firstCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[GSCategoryManager shardInstance] catagrArrCount];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstCell" forIndexPath:indexPath];
    
    GSFirrstModel *model = [[GSCategoryManager shardInstance] modelWithFirstIndex:indexPath.row];
    cell.label.text = model.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    return cell;
    
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
