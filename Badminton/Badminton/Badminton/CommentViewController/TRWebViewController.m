//
//  TRWebViewController.m
//  YouPlay
//
//  Created by try-ios on 2018/7/18.
//  Copyright © 2018年 Harvey. All rights reserved.
//

#import "TRWebViewController.h"
#import <WebKit/WebKit.h>

@interface TRWebViewController ()
@property (strong, nonatomic) WKWebView *webView;
@property (assign, nonatomic) NSInteger type;
@end

@implementation TRWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    
}

- (void)initView{
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    if(self.type < 4){
        UIButton *leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        [leftbutton addTarget:self action:@selector(shouchang:) forControlEvents:UIControlEventTouchUpInside];
        [leftbutton setImage:[UIImage imageNamed:@"video_like_no"] forState:0];
        [leftbutton setImage:[UIImage imageNamed:@"video_like"] forState:UIControlStateSelected];
        
        UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
        
        self.navigationItem.rightBarButtonItem = rightitem;
    }

}

- (void)shouchang:(UIButton *)sender{
    [sender setSelected:!sender.selected];
    if(self.loadDic){
        NSString *key = [NSString stringWithFormat:@"shouchang%@",@(self.type)];
        NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[user objectForKey:key]];
        [tempArray addObject:self.loadDic];
        [user setObject:tempArray forKey:key];
        [user synchronize];
    }

}


- (void)loadRequest:(NSString *)urlString withType:(NSInteger)type{
    self.type = type;
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]]];

}

- (WKWebView *)webView{
    if(!_webView){
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}

- (void)backAction{
    if(self.webView.canGoBack){
        [self.webView goBack];
    }
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
