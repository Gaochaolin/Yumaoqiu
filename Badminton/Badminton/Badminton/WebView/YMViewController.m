//
//  YIViewController.m
//  YIFootBall
//
//  Created by 玛丽 on 2018/7/2.
//  Copyright © 2018 玛丽. All rights reserved.
//

#import "YMViewController.h"
#import <Masonry.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Ali.h"
#import "AppDelegate.h"

@interface YMViewController ()<UIWebViewDelegate>
{
    UIView * _view;
    UIButton * _btn1;
    UIButton * _btn2;
    UIButton * _btna;
    UIButton * _btnb;
    UIWebView *_web;
    NSURLRequest *_request ;
}
@property (nonatomic, strong) NSMutableArray *masonryViewArray;
@property (nonatomic, strong) NSString *realUrl;
@end

@implementation YMViewController

// 设备支持方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
// 默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait; // 或者其他值 balabala~
}

// 开启自动转屏
- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    if (size.width > size.height) { // 横屏
        // 横屏布局 balabala
        
        for (int i = 0; i < 4; i++) {
            UIButton *btn = self.masonryViewArray[i];
            btn.frame = CGRectMake(self.view.frame.size.height/4 * i, 0 ,  self.view.frame.size.height/4,50);
        }
        
    } else {
        
        // 实现masonry水平固定控件宽度方法
        for (int i = 0; i < 4; i++) {
            UIButton *btn = self.masonryViewArray[i];
            btn.frame =CGRectMake(self.view.frame.size.height/4 * i, 0 ,  self.view.frame.size.height/4,50);
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    
}

- (void)loadUrl:(NSString *)urlstring{
    self.realUrl = urlstring;

}

-(void)viewDidAppear:(BOOL)animated {
    
    self.masonryViewArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor =[UIColor whiteColor];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD showInfoMessage:@"加载中..."];
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    UIWebView * webView =[[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    webView.delegate =self;
    webView.backgroundColor = [UIColor whiteColor];
    _web =webView;
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:self.realUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _request =request;
    [webView loadRequest:request];
    
    UIView * view =[[UIView alloc] init];
    _view = view;
    _view.hidden = YES;
    [self.view addSubview:view];
    
    
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(rectStatus.size.height));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(@(-50));
    }];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(webView.mas_bottom);
    }];
    
    
    
    NSArray * arr =@[@"icon_t1_nor@2x",@"icon_t2_nor@2x",@"icon_t3_nor@2x",@"icon_t4_nor@2x"];
    NSArray * selearr= @[@"icon_t1@2x",@"icon_t2@2x",@"icon_t3@2x",@"icon_t4@2x"];
    for (int i =0 ;  i <4 ;i ++){
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(self.view.frame.size.width/4 * i, 0 ,  self.view.frame.size.width/4,50);
        btn.tag =i;
        [btn setImage:[UIImage imageNamed:selearr [i]] forState:UIControlStateNormal];
        //        [btn setImage:[UIImage imageNamed:selearr [i]] forState:UIControlStateSelected];
        //        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [view addSubview:btn];
        
        [self.masonryViewArray addObject:btn];
        
        
        if (btn.tag ==1){
            _btn1 =btn;
            if (_web.canGoBack) {
                btn.enabled =YES;
                [btn setImage:[UIImage imageNamed:selearr [1]] forState:UIControlStateNormal];
            }else{
                btn.enabled =NO;
                [btn setImage:[UIImage imageNamed:arr [1]] forState:UIControlStateNormal];
            }
        }
        if ( btn.tag ==2) {
            _btn2 =btn;
            if (_web.canGoForward){
                btn.enabled =YES;
                [btn setImage:[UIImage imageNamed:selearr [2]] forState:UIControlStateNormal];
            }else{
                btn.enabled =NO;
                [btn setImage:[UIImage imageNamed:arr [2]] forState:UIControlStateNormal];
                //                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        }
        
        btn.backgroundColor =[UIColor whiteColor];
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccessMessage:@"加载成功"];
    
}

-(void)refreshButtonsState
{
    NSArray * arr =@[@"icon_t1_nor@2x",@"icon_t2_nor@2x",@"icon_t3_nor@2x",@"icon_t4_nor@2x"];
    NSArray * selearr= @[@"icon_t1@2x",@"icon_t2@2x",@"icon_t3@2x",@"icon_t4@2x"];
    if (_web.canGoForward){
        _btn2.enabled =YES;
        
        [_btn2 setImage:[UIImage imageNamed:selearr [2]] forState:UIControlStateNormal];
    }else{
        _btn2.enabled =NO;
        [_btn2 setImage:[UIImage imageNamed:arr [2]] forState:UIControlStateNormal];
    }
    
    
    if (_web.canGoBack) {
        _btn1.enabled =YES;
        [_btn1 setImage:[UIImage imageNamed:selearr [1]] forState:UIControlStateNormal];
        
    }else{
        _btn1.enabled =NO;
        [_btn1 setImage:[UIImage imageNamed:arr [1]] forState:UIControlStateNormal];
    }
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [self refreshButtonsState];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showInfoMessage:@"加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    
    _view.hidden =NO;
    [self refreshButtonsState];
    
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccessMessage:@"加载成功"];
    
}
-(void)btnClicked:(UIButton*)btn
{
    switch (btn.tag) {
        case 0:
            [_web loadRequest:_request];
            //            [_web stopLoading];
            break;
        case 1:
            if (_web.canGoBack) {
                [_web goBack];
            }
            
            break;
        case 2:
            if (_web.canGoForward) {
                [_web goForward];
            }
            break;
        case 3:
            //            if (isLoadOrNot) {
            //
            //            } else {
            [_web reload];
            //            }
            break;
        default:
            break;
    }
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
