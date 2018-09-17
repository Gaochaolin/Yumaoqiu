//
//  BaseViewController.m
//  PUBG
//
//  Created by Harvey on 2018/2/6.
//  Copyright © 2018年 Harvey. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

+ (instancetype)initStoryboard{
    NSString *selfClass = NSStringFromClass([self class]);
    UIStoryboard *stroye = [UIStoryboard storyboardWithName:selfClass
                                                     bundle:nil];
    
    return  [stroye instantiateViewControllerWithIdentifier:selfClass];
}

+ (instancetype)initStoryboardName:(NSString *)sbName{
    NSString *selfClass = NSStringFromClass([self class]);
    UIStoryboard *stroye = [UIStoryboard storyboardWithName:sbName
                                                     bundle:nil];
    id class =  [stroye instantiateViewControllerWithIdentifier:selfClass];
    return class;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configNavBar];
//    [self setUpNav];
//    [self setUp];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)configNavBar {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    if (@available(iOS 11.0, *)) {
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button.widthAnchor constraintEqualToConstant:30].active = YES;
        [button.heightAnchor constraintEqualToConstant:44].active = YES;
    }
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 10);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;


    
//    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

//- (void)setUpNav {
//
//}
//
//- (void)setUp {
//
//}
//
- (void)backAction {
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//
//
//
- (void)leftItemClickHandler:(UIButton *)item {
    [self backAction];
}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//- (void)hideNavLine {
//    UIImageView *shaddowImage = nil;
//    NSArray *subViews = [self getAllSubViews:self.navigationController.navigationBar];
//    for (UIView *view in subViews) {
//        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height<1){
//            shaddowImage = (UIImageView *)view;
//            break;
//        }
//    }
//    shaddowImage.hidden = YES;
//}
//
//- (NSArray *)getAllSubViews:(UIView *)view {
//    NSArray *results = [view subviews];
//    for (UIView *eachView in view.subviews) {
//        NSArray *subviews = [self getAllSubViews:eachView];
//        if (subviews)
//            results = [results arrayByAddingObjectsFromArray:subviews];
//    }
//    return results;
//}



- (void)dealloc
{
    NSLog(@"释放:%@",NSStringFromClass([self class]));
}




@end
