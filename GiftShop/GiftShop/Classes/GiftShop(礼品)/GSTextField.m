//
//  GSTextField.m
//  GiftShop
//
//  Created by WJ on 16/3/2.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "GSTextField.h"

@implementation GSTextField

- (void)awakeFromNib {
    
    self.tintColor = self.textColor;
    
    [self resignFirstResponder];
    
}


- (BOOL)becomeFirstResponder {
    
    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
    
    return  [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    return [super resignFirstResponder];
}

@end
