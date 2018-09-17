//
//  PersionViewController.m
//  Badminton
//
//  Created by try-ios on 2018/9/7.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import "PersionViewController.h"
#import "PersionTableViewCell.h"
#import "CollectionViewController.h"
#import "MBProgressHUD.h"
#import <SDWebImage/SDImageCache.h>
@interface PersionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic)NSArray *dataSource;
@end

@implementation PersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"新闻收藏",@"视频收藏",@"装备收藏",@"清除缓存"];
    self.mainTableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersionTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.dataSource[indexPath.row];
    if (indexPath.row == 3) {
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = [NSString stringWithFormat:@"%0.2fM",[[SDImageCache sharedImageCache] getSize] / 1024.f / 1024.f];
    }else{
        cell.rightLabel.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"清除中...";
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [hud hideAnimated:YES afterDelay:1];
            PersionTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            cell.rightLabel.text = @"0M";
        }];
    
    }else{
        CollectionViewController *coll = [CollectionViewController initStoryboardName:@"RootViewController"];
        coll.type = indexPath.row + 1;
        [self.navigationController pushViewController:coll animated:YES];
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
