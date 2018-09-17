//
//  HotViewControllere.m
//  Badminton
//
//  Created by try-ios on 2018/9/6.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import "HotViewControllere.h"
#import "SQNetWorkCenter.h"
#import "HotTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <MJRefresh.h>
#import "SDCycleScrollView.h"
#import "TRWebViewController.h"

@interface HotViewControllere ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *bannerArray;
@property (weak, nonatomic) IBOutlet UIView *bannerViewBackgroundView;
@property (strong, nonatomic) SDCycleScrollView *bannerView;
@end

@implementation HotViewControllere

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.bannerView adjustWhenControllerViewWillAppera];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.rowHeight = 120;
    self.mainTableView.tableFooterView = [UIView new];
    [self drawBannerView];
    __weak HotViewControllere *weakSelf = self;
    self.mainTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadData];
    }];
    [self reloadData];
}

- (void)drawBannerView{
    __weak HotViewControllere *weakSelf = self;
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 160) imageNamesGroup:@[]];
    self.bannerView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        NSString *url = weakSelf.bannerArray[currentIndex][@"url"];
        TRWebViewController *web = [[TRWebViewController alloc] init];
        [web loadRequest:url withType:4];
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    [self.bannerViewBackgroundView addSubview:self.bannerView];
}

- (void)reloadData{
    [SQNetWorkCenter requestDataofUrl:@"https://apibadmintonalone.app887.com/api/Articles.action" andParmeters:@{@"keyword":@"",@"kind":@"",@"opc":@"25",@"type":@"羽坛快讯",@"uid":@"1537272938806"} getWithBlock:^(id content, BOOL status) {
        if(status){
            self.dataArray = [NSMutableArray arrayWithArray:content[@"root"][@"list"]];
            [self.mainTableView reloadData];
            [self.mainTableView.mj_header endRefreshing];
        }
    }];
    
    //获取banner数据
    [SQNetWorkCenter requestDataofUrl:@"https://app.aiyuke.com/App/api.htm?clientOS=IOS&clientVer=4.9&api=News.Info&uid=&ssotoken=&ajax=1&app=1&from_app=ayk&appId=1A94EE94-2A2E-4BBB-98C6-F9A1FCD75BC5&havingid=&lat=30.546312&lng=104.068160&page=0&times=1" andParmeters:nil getWithBlock:^(id content, BOOL status) {
        if(status){
            self.bannerArray = [NSMutableArray arrayWithArray:content[@"msg"][@"slideImage"]];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *tempDic  in self.bannerArray) {
                NSString *url = tempDic[@"image"];
                [tempArray addObject:url];
            }
            self.bannerView.imageURLStringsGroup = tempArray;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotTableViewCell" forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"imglink"]]];
    cell.titleLabel.text = self.dataArray[indexPath.row][@"title"];
    cell.timeLabel.text = self.dataArray[indexPath.row][@"CTIME"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = [NSString stringWithFormat:@"%@&project=badminton&content=0&uid=1537272938806",self.dataArray[indexPath.row][@"urls"]];
    TRWebViewController *webView = [[TRWebViewController alloc] init];
     webView.loadDic = self.dataArray[indexPath.row];
    [webView loadRequest:url withType:1];
    [self.navigationController pushViewController:webView animated:YES];
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
