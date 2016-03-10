//
//  GSCategoryController.m
//  GiftShop
//
//  Created by WJ on 16/3/5.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryController.h"
#import "GSButton.h"
#import "GSCategoryModel.h"
#import "GSCategoryCell.h"
#import "GSHead.h"
#import "GSHeadView.h"
#import "GSCategoryTableCell.h"
#import "GSCollectionController.h"
#import "GSCollectionModel.h"
#import "GSGiftShopScrollController.h"
#import "GSGiftShop.h"
#import "GSCategoryGiftShop.h"
#import "GSCategoryLeftCell.h"
#import "GSCategoryRightCell.h"
#import "GSCategoryRightHead.h"
#import "GSCategoryCollectionController.h"
#import "GSCategoryListModel.h"
#import "GSSearchButton.h"
#import "GSChooseController.h"
#import "GSScrollListController.h"

@interface GSCategoryController ()<UITableViewDataSource, UITableViewDelegate, tapCollectionItemDelegate,firstCellDelegate, tapCollectionDelegate>

@property (nonatomic, strong) NSMutableArray *scrollViewArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableView *shopTableView;

@property (nonatomic, strong) UITableView *shopRightView;

@property (nonatomic, strong) UIView *strategyView;

@property (nonatomic, strong) UIView *shopGiftView;

@property (nonatomic, strong) NSMutableArray *headArray;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSMutableArray *giftShopLeftArray;

@property (nonatomic, assign) CGFloat rigthHeight;

@property (nonatomic, assign) BOOL isRelate;

@end



@implementation GSCategoryController

- (NSMutableArray *)giftShopLeftArray {
    if (!_giftShopLeftArray) {
        _giftShopLeftArray = [NSMutableArray array];
    }
    return _giftShopLeftArray;
}

- (NSMutableArray *)headArray {
    if (!_headArray) {
        _headArray = [NSMutableArray array];
    }
    return _headArray;
}

- (NSMutableArray *)scrollViewArray {
    if (!_scrollViewArray) {
        _scrollViewArray = [NSMutableArray array];
    }
    return _scrollViewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addStrategyView];
    
    [self addShopGiftView];
    
    [self addSegment];
    
    [self addTableView];
    
    GSSearchButton *button = [GSSearchButton button];
    [button.searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 64, ScreenWidth, 44);
    [self.shopGiftView addSubview:button];
    
    

    [self.view bringSubviewToFront:self.strategyView];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"204" target:self action:@selector(searchClick)];

}

- (void)searchButtonClick {
    
    GSChooseController *search = [[GSChooseController alloc] init];
    
    [self.navigationController pushViewController:search animated:YES];
}

- (void)searchClick {
    GSSearchController *search = [[GSSearchController alloc] init];
    
    [self.navigationController pushViewController: search animated:YES];
}

- (void)addStrategyView {
    
    UIView *strategyView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    self.strategyView = strategyView;
    [self.view addSubview:strategyView];
    
}

- (void)addShopGiftView {
    
    UIView *shopGiftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.shopGiftView = shopGiftView;
    shopGiftView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:shopGiftView];
    
    self.shopTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 100, ScreenHeight - 44) style:UITableViewStylePlain];

    self.shopTableView.delegate = self;
    self.shopTableView.dataSource = self;
    
    [self.shopGiftView addSubview:self.shopTableView];
    
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GSCategoryLeftCell class]) bundle:nil] forCellReuseIdentifier:@"GSCategoryLeftCell"];
    
    self.shopRightView = [[UITableView alloc] initWithFrame:CGRectMake(100, 108, ScreenWidth - 100, ScreenHeight - 64 - 44)style:UITableViewStylePlain];
    self.shopRightView.backgroundColor = [UIColor whiteColor];
    
    self.shopRightView.delegate = self;
    self.shopRightView.dataSource =self;
    
    [self.shopGiftView addSubview:self.shopRightView];
    
     [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GSCategoryRightCell class]) bundle:nil] forCellReuseIdentifier:@"GSCategoryRightCell"];
    
    [self giftShopLeftData];
}

- (void)giftShopLeftData {
    
    [[AFHTTPSessionManager manager] GET:@"http://api.liwushuo.com/v2/item_categories/tree" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = responseObject[@"data"][@"categories"];
        for (NSDictionary *dict in array) {
            GSCategoryGiftShop *gift = [[GSCategoryGiftShop alloc] initWithDict:dict];
            [self.giftShopLeftArray addObject:gift];
            [self.shopTableView reloadData];
        }
        [self.shopTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)addSegment {
    NSArray *array = @[@"攻略", @"礼物"];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    
    segment.frame = CGRectMake((ScreenWidth - 200) / 2, 20, ScreenWidth - 200, 30);
    
    segment.selectedSegmentIndex = 0;
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    [segment setTintColor:[UIColor whiteColor]];
    
    [segment addTarget:self action:@selector(selectedSegmentClick:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segment;
    
}

- (void)addTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.strategyView addSubview:self.tableView];
    
     [self setFirst];
    [self addHead];
}

- (void)setFirst {
    [[AFHTTPSessionManager manager]GET:@"http://api.liwushuo.com/v2/collections?limit=6&offset=0" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *array= responseObject[@"data"][@"collections"];
        for (NSDictionary *dict in array) {
            GSCategoryModel *model = [[GSCategoryModel alloc] initWithDict:dict];
            [self.scrollViewArray addObject:model];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)segmentButton {
    GSScrollListController *scroll = [[GSScrollListController alloc] init];
    
    [self.navigationController pushViewController:scroll animated:YES];
}

- (void)addHead {
    [[AFHTTPSessionManager manager]GET:@"http://api.liwushuo.com/v2/channel_groups/all" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = responseObject[@"data"][@"channel_groups"];
        for (NSDictionary *dict in array) {
            GSHead *head = [[GSHead alloc] initWithDict:dict];
            [self.headArray addObject:head];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)selectedSegmentClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.strategyView];
    } else  {
        [self.view bringSubviewToFront:self.shopGiftView];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (section == 0) {
            GSButton *button = [GSButton button];
            
            [button.button addTarget:self action:@selector(segmentButton) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
        GSHeadView *headView = [GSHeadView head];
        headView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 30);
        GSHead *data = self.headArray[section - 1];
        headView.headLabel.text = data.name;
        return headView;
    } else if (tableView == self.shopRightView) {

        GSCategoryRightHead *headView = [GSCategoryRightHead head];
        headView.bounds = CGRectMake(0, 0, self.shopRightView.bounds.size.width, 50);
        GSCategoryGiftShop *data = self.giftShopLeftArray[section];
        headView.headLabel.text = data.name;
       
        return headView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.shopRightView) {
        return 0.01;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
    return 50;
    } else if (tableView == self.shopRightView) {
        return 30;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
   return 1;
    } else if (tableView == self.shopRightView) {
         return 1;
    } else {
        return self.giftShopLeftArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
    return  self.headArray.count+ 1;
    } else if (tableView == self.shopRightView) {
        return self.giftShopLeftArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            GSCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"index"];
            if (!cell) {
                cell = [[GSCategoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"index"];
            }
            cell.delegate = self;
            cell.data = self.scrollViewArray;
            
            return cell;
        } else {
            GSCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSCategoryCollectionCell"];
            if (!cell) {
                cell = [[GSCategoryTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GSCategoryCollectionCell"];
            }
            
            if (self.headArray != nil && ![self.headArray isKindOfClass:[NSNull class]] && self.headArray.count != 0) {
                
                cell.delegate = self;
                cell.head = self.headArray[indexPath.section - 1];
                NSInteger num = cell.head.channels.count;
                if (num % 4 == 0) {
                    self.height = (cell.head.channels.count / 4) * (((ScreenWidth - 50) / 4) + 50);
                } else {
                    self.height = (cell.head.channels.count / 4 + 1 ) * (((ScreenWidth - 50) / 4) + 50);
                }
                
                return cell;
                
            }
            return nil;
            
        }
        
    }else if (tableView == self.shopTableView){
        
        GSCategoryLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSCategoryLeftCell"];
        if (!cell) {
            cell = [[GSCategoryLeftCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GSCategoryLeftCell"];
        }
        
        if (self.giftShopLeftArray != nil && ![self.giftShopLeftArray isKindOfClass:[NSNull class]] && self.giftShopLeftArray.count != 0) {
            
            GSCategoryGiftShop *gift = self.giftShopLeftArray[indexPath.row];
            cell.giftShop = gift;
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
            return cell;
        }
        return nil;
        
    } else {
        
        GSCategoryRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSCategoryRightHead"];
        if (!cell) {
            cell = [[GSCategoryRightCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GSCategoryRightHead"];
        }
        
        if (self.giftShopLeftArray != nil && ![self.giftShopLeftArray isKindOfClass:[NSNull class]] && self.giftShopLeftArray.count != 0) {
            
            cell.delegate = self;
            cell.giftShop = self.giftShopLeftArray[indexPath.section];
            cell.textLabel.font = [UIFont systemFontOfSize:10];
            
            NSInteger num = cell.giftShop.subcategories.count;
            if (num % 3 == 0) {
                self.rigthHeight = (num / 3) * (((ScreenWidth -100) / 3) + 22);
            } else {
                self.rigthHeight = (num / 3 + 1 ) * (((ScreenWidth - 100) / 3) + 22);
            }
            return cell;
        }
        
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
    
        if (indexPath.section == 0) {
            return 100;
        }
        
        return self.height;
    } else if (tableView == self.shopRightView) {
        return self.rigthHeight;
    }
    return 50;
}


- (void)firstCellClick:(UIButton *)sender {
    
    GSCategoryModel *giftshop = self.scrollViewArray[sender.tag];
    
    GSGiftShopScrollController *gift = [[GSGiftShopScrollController alloc] init];
    gift.url = giftshop.Nid;
    gift.nameTitle = giftshop.title;
    [self.navigationController pushViewController:gift animated:YES];
    
}
- (void)tapCollection:(GSCollectionModel *)model {
    
    GSCollectionController *gift = [[GSCollectionController alloc] init];
    
    gift.nameTitle = model.name;
    gift.url = model.Nid;
    
    [self.navigationController pushViewController:gift animated:YES];
}

- (void)tapRightCollection:(GSCollectionModel *)model {
    
    GSCategoryCollectionController *hot = [[GSCategoryCollectionController alloc] init];
    hot.urlID = model.Nid;
    hot.name = model.name;
    [self.navigationController pushViewController:hot animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    _isRelate = NO;
    [self.shopTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
    //点击了左边的cell，让右边的tableView跟着滚动
    [self.shopRightView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == self.shopRightView) {
            [self.shopTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == self.shopRightView) {
            [self.shopTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isRelate = YES;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。注意跟ios6.0之前的区分
    // Add code to clean up any of your own resources that are no longer necessary.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。

        }
    }
    

}
@end
