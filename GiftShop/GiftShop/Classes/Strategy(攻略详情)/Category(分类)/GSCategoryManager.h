//
//  GSCategoryManager.h
//  GiftShop
//
//  Created by coder_xue on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GSCategoryModel;
@class GSFirrstModel;
@interface GSCategoryManager : NSObject
@property (nonatomic,strong)GSCategoryModel *ImageModel;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *nameArr;
@property (nonatomic,strong)NSMutableArray *catagryArr;
+ (instancetype)shardInstance;


- (void)requestWithUrl:(NSString *)url finish:(void(^)())finish;
- (void)requestCategoryWithUrl:(NSString *)url finish:(void(^)())finish;

- (NSInteger)countToArray;
- (NSInteger)catagrArrCount;

- (GSCategoryModel *)modelWithIndex:(NSInteger)index;
- (GSFirrstModel *)modelWithFirstIndex:(NSInteger)index ;
@end
