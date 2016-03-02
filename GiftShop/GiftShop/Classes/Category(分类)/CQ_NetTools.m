//
//  CQ_NetTools.m
//  UILesson17_NetWorking2
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 符雪苑. All rights reserved.
//

#import "CQ_NetTools.h"

@implementation CQ_NetTools


+ (void)solveDataWithUrl:(NSString *)StringUrl HttopMethod:(NSString *)method HttpBoody:(NSString *)StringBoody revokeBlock:(Datablock)block {
    
    NSURL *url = [NSURL URLWithString:StringUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
//    将所有的字母转换成大写
    NSString *SMethod = [method uppercaseString];
    if ([@"POST" isEqualToString:SMethod]) {
        [request setHTTPMethod:SMethod];
        NSData *bodyData = [StringBoody dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
    } else if ([@"GET" isEqualToString:SMethod]) {
        
    } else {
//        NSLog(@"方法类型参数错误");
        
        @throw [NSException exceptionWithName:@"CQ Param Error" reason:@"方法类型参数错误" userInfo:nil];
        return;
    }
//    发送请求拿到data
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        block(data);
        
    }];
    
    
    
    
}


+ (void)SessionDownloadWithUrl:(NSString *)stringUrl revokeBlock:(ImageSolveBlock)block {
//    创建URL
    NSURL *url = [NSURL URLWithString:stringUrl];
//    2 创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    3创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    
//    4创建任务
    NSURLSessionDownloadTask *tast = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *Imagedata = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:Imagedata];
        
//        从子线程回到主线程进行页面更新 （ios界面跟新只能在主线程）
        dispatch_async(dispatch_get_main_queue(), ^{
            block(image);
        });
    }];
    [tast resume];
    
    
}



@end
