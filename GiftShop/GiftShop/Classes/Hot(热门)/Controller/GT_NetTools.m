//
//  GT_NetTools.m
//  UILesson17_NetWorking2
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 郭涛. All rights reserved.
//

#import "GT_NetTools.h"

@implementation GT_NetTools

+ (void)solveDataWithUrl:(NSString *)stringUrl HttpMethod:(NSString *)method HttpBody:(NSString *)stringBody revokeBlock:(DataBlock)block {
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 将所有的字母转换成大写
    NSString *Smethod = [method uppercaseString];
    if ([@"POST" isEqualToString:Smethod]) {
        [request setHTTPMethod:Smethod];
        NSData *bodyData = [stringBody dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
    }else if([@"GET" isEqualToString:Smethod]) {
        
    }else {
        @throw [NSException exceptionWithName:@"Param Error" reason: @"方法类型参数错误" userInfo:nil];
//        NSLog(@"方法类型参数错误");
        return;
    }

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        block(data);
    }];
}

+ (void)SessionDownLoadWithUrl:(NSString *)stringUrl revokeBlock:(ImageSolveBlock)block {
    // 创建URl
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 创建session
    NSURLSession *session = [NSURLSession sharedSession];
    // 创建任务
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *imageData = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:imageData];
        // 从子线程回到主线程进行界面跟新
        dispatch_async(dispatch_get_main_queue(), ^{
            block(image);
        });
    }];
    
    [task resume];
}







@end
