//
//  GSCategoryManager.m
//  GiftShop
//
//  Created by coder_xue on 16/3/1.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSCategoryManager.h"
#import "CQ_NetTools.h"
#import "GSCategoryModel.h"
#import "GSFirrstModel.h"
@interface GSCategoryManager ()

@end

static GSCategoryManager *manager = nil;
@implementation GSCategoryManager

+ (instancetype)shardInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager  = [[GSCategoryManager alloc] init];
        
    });
    return manager;
}

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)nameArr {
    if (!_nameArr) {
        _nameArr = [NSMutableArray array];
    }
    return _nameArr;
}

- (NSMutableArray *)catagryArr {
    if (!_catagryArr) {
        _catagryArr = [NSMutableArray array];
    }
    return _catagryArr;
}

// 加载sliderIMage
- (void)requestWithUrl:(NSString *)url finish:(void(^)())finish {
    [CQ_NetTools solveDataWithUrl:url HttopMethod:@"GET" HttpBoody:nil revokeBlock:^(NSData *data) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableDictionary *dict = dic[@"data"];
        NSMutableArray *arr = dict[@"collections"];
        for (NSDictionary *dictImage in arr) {
            GSCategoryModel *model = [[GSCategoryModel alloc] init];
            [model setValuesForKeysWithDictionary:dictImage];
            [self.dataArr addObject:model];
        }
//        NSLog(@"%@",_dataArr);
        finish();
    }];
    
}

- (void)requestCategoryWithUrl:(NSString *)url finish:(void (^)())finish {
    
    [CQ_NetTools solveDataWithUrl:url HttopMethod:@"get" HttpBoody:nil revokeBlock:^(NSData *data) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",dic);
        NSMutableDictionary *dict = dic[@"data"];

//        NSLog(@"%@",dict[@"channel_groups"]);
        for (NSDictionary *d in dict[@"channel_groups"]) {
//                NSLog(@"%@",d[@"channels"]);
            for (NSDictionary *dictionary in d[@"channels"]) {
                GSFirrstModel *model = [[GSFirrstModel alloc] init];
                [model setValuesForKeysWithDictionary:dictionary];
                [self.catagryArr addObject:model];
                NSLog(@"%@", self.catagryArr);
        }
        }
//
    }];
    
}

- (NSInteger)countToArray {
    
    return self.dataArr.count;
}

- (NSInteger )catagrArrCount {
    return self.catagryArr.count;
}

- (GSFirrstModel *)modelWithFirstIndex:(NSInteger)index {
    
    GSFirrstModel *model = self.catagryArr[index];
    return model;
    
}

- (GSCategoryModel *)modelWithIndex:(NSInteger)index {
    
    GSCategoryModel *model = self.dataArr[index];
    return model;
}


@end
