//
//  BaseView.h
//  YouPlay
//
//  Created by Harvey on 2018/7/5.
//  Copyright © 2018年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

/**
 转用与xib初始化
 */
+ (instancetype)initXiBView;


- (void)setUp;
@end
