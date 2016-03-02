//
//  GT_NetTools.h
//  UILesson17_NetWorking2
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 郭涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^DataBlock)(NSData *data);

typedef void(^ImageSolveBlock)(UIImage *image);

@interface GT_NetTools : NSObject
// 封装的旧方法
+ (void)solveDataWithUrl:(NSString *)stringUrl HttpMethod:(NSString *)method HttpBody:(NSString *)stringBody revokeBlock:(DataBlock)block;
// 如果是下载图片
+ (void)SessionDownLoadWithUrl:(NSString *)stringUrl revokeBlock:(ImageSolveBlock)block;
@end
