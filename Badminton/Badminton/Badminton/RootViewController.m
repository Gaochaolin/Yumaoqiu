//
//  RootViewController.m
//  Badminton
//
//  Created by 高超林 on 2018/9/12.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

+ (instancetype)initStoryboard{
    NSString *selfClass = NSStringFromClass([self class]);
    UIStoryboard *stroye = [UIStoryboard storyboardWithName:selfClass
                                                     bundle:nil];
    
    return  [stroye instantiateViewControllerWithIdentifier:selfClass];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
