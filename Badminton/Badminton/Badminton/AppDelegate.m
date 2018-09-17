//
//  AppDelegate.m
//  Badminton
//
//  Created by try-ios on 2018/9/6.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bmob registerWithAppKey:@"4a66f81bd767b1f661b0e7a3a6ebcd32"];
    BmobQuery  *bquery = [BmobQuery queryWithClassName:@"info"];
    [bquery getObjectInBackgroundWithId:@"61a3fb28f3" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                BOOL isAuto = [object objectForKey:@"isAuto"];
                NSString *url = [object objectForKey:@"url"];

                NSLog(@"%@----%@",isAuto?@"1":@"0",url);
            }
        }
    }];
    
    RootViewController *root = [RootViewController initStoryboard];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
