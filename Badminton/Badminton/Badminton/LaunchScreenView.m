//
//  LaunchScreenView.m
//  Badminton
//
//  Created by try-ios on 2018/9/17.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import "LaunchScreenView.h"

@implementation LaunchScreenView

- (void)showOfView:(UIView *)superView{
    [superView addSubview:self];
    self.frame = superView.bounds;
}


@end
