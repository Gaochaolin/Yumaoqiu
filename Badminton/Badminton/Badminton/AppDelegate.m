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
#import "AFNetworking.h"
#import "YMViewController.h"
#import "JPUSHService.h"
#import <CoreTelephony/CTCellularData.h>
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "MainViewController.h"



@interface AppDelegate ()
@property (nonatomic, assign) BOOL reteurnNetworkOff;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [Bmob registerWithAppKey:@"4a66f81bd767b1f661b0e7a3a6ebcd32"];

    MainViewController *root = [MainViewController initStoryboardName:@"RootViewController"];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];
    
    

    if (__IPHONE_10_0) {
        [self networkStatus:application didFinishLaunchingWithOptions:launchOptions];
    }else {
    }

    [self registerPushService];
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"097d91ae6a11307222b70bc6"
                          channel:@"appstore"
                 apsForProduction:NO];
    return YES;
}



/*
 CTCellularData在iOS9之前是私有类，权限设置是iOS10开始的，所以App Store审核没有问题
 获取网络权限状态
 */
- (void)networkStatus:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //2.根据权限执行相应的交互
    /*
     此函数会在网络权限改变时再次调用
     */
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                switch (state) {
                    case kCTCellularDataRestricted:{
                        self.reteurnNetworkOff = YES;
                    }
                        break;
                    case kCTCellularDataNotRestricted:
                    {
                        if (self.reteurnNetworkOff) {
                            MainViewController *main = (MainViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
                            [main reloadData];
                        }
                    }
                        break;
                    case kCTCellularDataRestrictedStateUnknown:
                        
                        
                        break;
                        
                    default:
                        break;
                }
            });
        };
    } else {
        // Fallback on earlier versions
    }
}






- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    [application setApplicationIconBadgeNumber:0];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
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

- (void)registerPushService
{
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]){
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |      UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else{
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |        UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
}


@end
