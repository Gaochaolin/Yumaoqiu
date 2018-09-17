//
//  BaseViewController.h
//  PUBG
//
//  Created by Harvey on 2018/2/6.
//  Copyright © 2018年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PGLoginController.h"
@interface BaseViewController : UIViewController

/**
 专用SB初始化
 */
+ (instancetype)initStoryboard;

/**
 在sbName 里面寻找当前类的初始化
 */
+ (instancetype)initStoryboardName:(NSString *)sbName;

- (void)backAction;

//
- (void)hideNavLine;

- (void)setUpNav;

- (void)setUp;

/// 在viewloadid 调用 是否隐藏导航栏
@property (nonatomic, assign) BOOL navigationBarHidden;


@end
