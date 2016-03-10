//
//  GSAPP.m
//  GiftShop
//
//  Created by WJ on 16/3/9.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSAPP.h"

@implementation GSAPP

- (instancetype)initWithDict:(NSDictionary *)dict {
    GSAPP *app = [[GSAPP alloc] init];
    
    app.download_url = dict[@"download_url"];
    
    app.icon_url = dict[@"icon_url"];
    
    app.subtitle = dict[@"subtitle"];
    
    app.title = dict[@"title"];
    
    return app;
}
@end
