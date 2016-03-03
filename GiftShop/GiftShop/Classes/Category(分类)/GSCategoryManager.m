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
#import "GSGiftModel.h"
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
        
        self.dicA = [NSMutableDictionary dictionary];
        self.firstHeadArr = [NSMutableArray array];
        
        for (NSDictionary *d in dict[@"channel_groups"]) {
            NSString  *name = d[@"name"];
//            NSLog(@"%@",name);
            [self.firstHeadArr addObject:name];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSDictionary *dictionary in d[@"channels"]) {
                GSFirrstModel *model = [[GSFirrstModel alloc] init];
                [model setValuesForKeysWithDictionary:dictionary];
                [arr addObject:model];
//                NSLog(@"%@", model.name);
//                [arr addObject:self.catagryArr];
        }
         
            [self.dicA setValue:arr forKey:name];
        
        }
//        NSLog(@"%@",self.dicA);

//
        finish();
    }];
    
}

- (NSInteger)countToArray {
    
    return self.dataArr.count;
}



- (GSCategoryModel *)modelWithIndex:(NSInteger)index {
    
    GSCategoryModel *model = self.dataArr[index];
    return model;
}
#pragma mark-----presentMethod

- (void)requestPresentWithUrl:(NSString *)url finish:(void (^)())finish {

    [CQ_NetTools solveDataWithUrl:url HttopMethod:@"get" HttpBoody:nil revokeBlock:^(NSData *data) {
        
        NSMutableDictionary *dic1 =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableDictionary *dict = dic1[@"data"];
        self.nameArr = [NSMutableArray array];
      self.dictName = [NSMutableDictionary dictionary];
//        NSLog(@"%@",dictName);
        for (NSMutableDictionary *dic in dict[@"categories"]) {
            NSString *name = dic[@"name"];
//            NSLog(@"%@",name);
            [self.nameArr addObject:name];
            
            NSMutableArray *catrArr = [NSMutableArray array];
            
            for (NSDictionary *dictCtr in dic[@"subcategories"]) {
                
                GSGiftModel *model = [[GSGiftModel alloc] init];
                [model setValuesForKeysWithDictionary:dictCtr];
                [catrArr addObject:model];
            }
            
            [self.dictName setValue:catrArr forKey:name];
            
        }
//        NSLog(@"%@",self.dictName);
        NSLog(@"%@",self.nameArr);
        finish ();
    }];
    
}
@end
