//
//  ViedoCollectionViewCell.m
//  Badminton
//
//  Created by try-ios on 2018/9/7.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import "ViedoCollectionViewCell.h"

@implementation ViedoCollectionViewCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:199.0/255.0].CGColor;
}
@end
