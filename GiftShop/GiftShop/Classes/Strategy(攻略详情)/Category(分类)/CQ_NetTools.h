//
//  CQ_NetTools.h
//  UILesson17_NetWorking2
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 符雪苑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^Datablock)(NSData *data);

typedef void(^ImageSolveBlock)(UIImage *image);


@interface CQ_NetTools : NSObject
//封装的旧方法
+ (void)solveDataWithUrl:(NSString *)StringUrl HttopMethod:(NSString *)method HttpBoody:(NSString *)StringBoody revokeBlock:(Datablock)block;

//新方法
// 如果是解析


// 如果是下载图片
+ (void)SessionDownloadWithUrl:(NSString *)stringUrl revokeBlock:(ImageSolveBlock)block;

@end
