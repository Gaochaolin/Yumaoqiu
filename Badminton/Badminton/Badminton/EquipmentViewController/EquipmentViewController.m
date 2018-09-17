//
//  EquipmentViewController.m
//  Badminton
//
//  Created by try-ios on 2018/9/10.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import "EquipmentViewController.h"
#import "EquipmentCell.h"
#import "SQNetWorkCenter.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "TRWebViewController.h"

@interface EquipmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation EquipmentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    self.mainTableView.tableFooterView = [UIView new];
    self.currentPage = 0;
    [self handleData:self.currentPage];
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
}

- (void)handleData:(NSInteger)page{
    NSString *url = @"https://apibadmintonalone.app887.com/api/Articles.action";
    [SQNetWorkCenter requestDataofUrl:url andParmeters:@{@"keyword":@"",@"kind":@"",@"npc":@(page),@"opc":@"25",@"type":@"装备评测",@"uid":@"1537272938806"} getWithBlock:^(id content, BOOL status) {
        if (page == 0) {
            self.dataArray = [NSMutableArray array];
        }
        NSArray *tempArray = [NSArray arrayWithArray:content[@"root"][@"list"]];
        for (int i = 0; i < tempArray.count; i ++) {
            [self.dataArray addObject:tempArray[i]];
        }
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EquipmentCell" forIndexPath:indexPath];
    NSDictionary *tempDic = self.dataArray[indexPath.row];
    [cell.faceImageView sd_setImageWithURL:[NSURL URLWithString:tempDic[@"imglink_1"]]];
    cell.titleLabel.text = tempDic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = [NSString stringWithFormat:@"%@&project=badminton&content=0&uid=1537272938806",self.dataArray[indexPath.row][@"urls"]];
    TRWebViewController *webView = [[TRWebViewController alloc] init];
    webView.loadDic = self.dataArray[indexPath.row];
    [webView loadRequest:url withType:3];
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
