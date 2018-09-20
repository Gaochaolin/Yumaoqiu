//
//  MainViewController.m
//  Badminton
//
//  Created by try-ios on 2018/9/19.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import "MainViewController.h"
#import <BmobSDK/Bmob.h>
#import "LaunchScreenView.h"
#import "YMViewController.h"
#import "RootViewController.h"

@interface MainViewController ()
@property (strong, nonatomic)LaunchScreenView *launchView;
@property (strong, nonatomic)RootViewController *root;
@property (strong, nonatomic)YMViewController *webView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLaunch];
    [self reloadData];
}

- (void)reloadData{
    [self handleData];
}

- (void)handleData{
    BmobQuery  *bquery = [BmobQuery queryWithClassName:@"info"];
    [bquery getObjectInBackgroundWithId:@"61a3fb28f3" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
            [self showTableBar];
        }else{
            if (object) {
                //得到playerName和cheatMode
                BOOL appIsAuto = [[object objectForKey:@"isAuto"] boolValue];
                NSString *url = [NSString stringWithFormat:@"%@",[object objectForKey:@"url"]];
                if (appIsAuto) {
                    if (self.webView) {
                        [self.webView removeFromParentViewController];
                        [self.webView.view removeFromSuperview];
                         self.webView = nil;
                    }
                    self.webView = [[YMViewController alloc] init];
                    [self.webView loadUrl:url];
                    [self.view addSubview:self.webView.view];
                    [self addChildViewController:self.webView];
                }else{
                    [self showTableBar];
                }
                NSLog(@"%@----%@",appIsAuto?@"1":@"0",url);
            }
            [self removeLuanch];
        }
    }];
}

- (void)showTableBar{
    if (self.root) {
        [self.root removeFromParentViewController];
        [self.root.view removeFromSuperview];
         self.root = nil;
    }
     self.root = [RootViewController initStoryboard];
    [self.view addSubview:self.root.view];
    [self addChildViewController:self.root];
}


- (void)removeLuanch{
    [self.launchView removeFromSuperview];
    self.launchView = nil;
}


- (void)showLaunch{
    self.launchView = [LaunchScreenView initXiBView];
    [self.launchView showOfView:self.view.window];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
