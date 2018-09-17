//
//  TRWebViewController.h
//  YouPlay
//
//  Created by try-ios on 2018/7/18.
//  Copyright © 2018年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRWebViewController : UIViewController
@property (strong,nonatomic)NSDictionary *loadDic;
- (void)loadRequest:(NSString *)urlString withType:(NSInteger)type;
@end
