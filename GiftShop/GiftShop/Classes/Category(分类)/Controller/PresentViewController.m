//
//  PresentViewController.m
//  GiftShop
//
//  Created by coder_xue on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "PresentViewController.h"
#import "GSCollectionViewCell.h"
#import "GSCategoryManager.h"
#import "GSGiftModel.h"
#import "UIImageView+WebCache.h"
#import "GSHeaderCollectionReusableView.h"
static NSString *itemIndertifer = @"Rcell";
#define PRESENTURL @"http://api.liwushuo.com/v2/item_categories/tree"

@interface PresentViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollection;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
////<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
////@property (weak, nonatomic) IBOutlet UILabel *headLabel;
//@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;
//
//@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
//
@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    
    self.rightCollection.dataSource = self;
    self.rightCollection.delegate = self;
    
    [self loadItem];
    [self registData];
    [self loadData];
    [[GSCategoryManager shardInstance]requestPresentWithUrl:PRESENTURL finish:^{
        [self.rightCollection reloadData];
    }];
    
//    [self registData];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadItem {
    UICollectionViewFlowLayout *firstLayout = [[UICollectionViewFlowLayout alloc] init];
    firstLayout.itemSize = CGSizeMake((self.rightCollection.bounds.size.width  - 30) / 3, 150);
    firstLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    firstLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    firstLayout.minimumInteritemSpacing = 10;
    firstLayout.minimumLineSpacing = 10;
    firstLayout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
    firstLayout.headerReferenceSize = CGSizeMake(320, 50);
    self.rightCollection.collectionViewLayout = firstLayout;
    

}
- (void)registData {
    [self.rightCollection registerNib:[UINib nibWithNibName:@"GSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:itemIndertifer];
    
     [self.rightCollection registerClass:[GSHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
  
    if (kind == UICollectionElementKindSectionHeader){

        GSHeaderCollectionReusableView *headerView = (GSHeaderCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
        
        switch (indexPath.section) {
            case 0:{
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[0];
                break;
            }
            case 1: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[1];
                break;

                   }
            case 2: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 3:
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            case 4: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 5: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 6: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 7: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 8: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 9: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 10: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 11: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 12: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 13: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 14: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 15: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            case 16: {
                headerView.label.text = [GSCategoryManager shardInstance].nameArr[indexPath.section];
                break;
            }
            default:
                break;
        }
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 17;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    switch (section) {
        case 0:{
            return [[GSCategoryManager shardInstance].dictName[@"热门分类"] count];
        }
        case 1:{
            return [[GSCategoryManager shardInstance].dictName[@"个性配饰 "] count];
        }
        case 2:{
            return [[GSCategoryManager shardInstance].dictName[@"温暖家居"] count];
        }
        case 3:
        {
            return [[GSCategoryManager shardInstance].dictName[@"美味厨房"] count];
        }
        case 4:
        {
            return [[GSCategoryManager shardInstance].dictName[@"美味礼物"] count];
        }
        case 5:{
           return [[GSCategoryManager shardInstance].dictName[@"数码小物"] count];
        }
        case 6:{
            return [[GSCategoryManager shardInstance].dictName[@"创意文具"] count];

        }
        case 7:{
            return [[GSCategoryManager shardInstance].dictName[@"美容护肤"] count];
        }
        case 8:{
            return [[GSCategoryManager shardInstance].dictName[@"精致彩妆"] count];
        }
        case 9:{
            return [[GSCategoryManager shardInstance].dictName[@"运动户外"] count];
        }
        case 10:{
            return [[GSCategoryManager shardInstance].dictName[@"身体保健"] count];
        }
        case 11:{
            return [[GSCategoryManager shardInstance].dictName[@"女装"] count];
        }
        case 12:{
            return [[GSCategoryManager shardInstance].dictName[@"箱包"] count];
        }
        case 13:{
            return [[GSCategoryManager shardInstance].dictName[@"女鞋"] count];
        }
        case 14:{
            return [[GSCategoryManager shardInstance].dictName[@"男装"] count];
        }
        case 15:{
            return [[GSCategoryManager shardInstance].dictName[@"男鞋"] count];
        }
        case 16:{
            return [[GSCategoryManager shardInstance].dictName[@"母婴"] count];
        }

        default:
            break;
    }
    return 0;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIndertifer forIndexPath:indexPath];

    switch (indexPath.section) {
        case 0:{
            NSMutableArray *arr = [GSCategoryManager shardInstance].dictName[@"热门分类"];
            GSGiftModel *model = arr[indexPath.row];
            cell.model = model;
            break;
        }
        case 1:{
            NSMutableArray *arr = [GSCategoryManager shardInstance].dictName[@"个性配饰 "];
            GSGiftModel *model = arr[indexPath.row];
            cell.model = model;
            break;
        }
        case 2:{
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"温暖家居"][indexPath.row];
            cell.model = model;

            break;
        }
        case 3: {
            NSMutableArray *arr = [GSCategoryManager shardInstance].dictName[@"美味厨房"];
            GSGiftModel *model = arr[indexPath.row];
            cell.model = model;

            break;

        }
        case 4: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"美味礼物"][indexPath.row];
            cell.model = model;
            break;
        }
        case 5: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"数码小物"][indexPath.row];
            cell.model = model;
            break;
        }
        case 6: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"创意文具"][indexPath.row];
            cell.model = model;
            break;
        }
        case 7: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"美容护肤"][indexPath.row];
            cell.model = model;
            break;
        }
        case 8: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"精致彩妆"][indexPath.row];
            cell.model = model;
            break;
        }
        case 9: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"运动户外"][indexPath.row];
            cell.model = model;
            break;
        }
        case 10: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"身体保健"][indexPath.row];
            cell.model = model;
            break;
        }
        case 11: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"女装"][indexPath.row];
            cell.model = model;
            break;
        }
        case 12: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"箱包"][indexPath.row];
            cell.model = model;
            break;
        }
        case 13: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"女鞋"][indexPath.row];
            cell.model = model;
            break;
        }
        case 14:{
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"男装"][indexPath.row];
            cell.model = model;
            break;

        }
        case 15: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"男鞋"][indexPath.row];
            cell.model = model;
            break;

        }
        case 16: {
            GSGiftModel *model = [GSCategoryManager shardInstance].dictName[@"母婴"][indexPath.row];
            cell.model = model;
            break;

        }
            
        default:
            break;
    }
    
    return cell;
    
}


- (void)loadData {
    self.dataArr = @[@"热门分类",@"个性配饰",@"温暖家居",@"美味厨房",@"美味礼物",@"数码小物",@"创意文具",@"美容护肤",@"精致彩妆",@"运动户外",@"身体保健",@"女装", @"箱包",@"女鞋",@"男装",@"男鞋",@"母婴"].mutableCopy;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
    
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
