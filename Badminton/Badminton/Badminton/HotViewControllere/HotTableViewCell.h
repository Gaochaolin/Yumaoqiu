//
//  HotTableViewCell.h
//  Badminton
//
//  Created by try-ios on 2018/9/6.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
