//
//  GSFirstCell.h
//  GiftShop
//
//  Created by WJ on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol firstCellDelegate <NSObject>

- (void)firstCellClick:(UIButton *)sender;

@end

@interface GSFirstCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) id<firstCellDelegate> delegate;
@end
