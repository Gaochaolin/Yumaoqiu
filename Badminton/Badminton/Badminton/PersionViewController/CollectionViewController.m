//
//  CollectionViewController.m
//  Badminton
//
//  Created by try-ios on 2018/9/12.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import "CollectionViewController.h"
#import "VideoTableViewCell.h"
#import "HotTableViewCell.h"
#import "VideoTableViewCell.h"
#import "TRWebViewController.h"
#import "UIImageView+WebCache.h"
#import "EquipmentCell.h"
#import "UIScrollView+EmptyDataSet.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initView];
}

- (void)initView{
    if(self.type == 3){
        self.mainTableView.rowHeight = 210;
    }else{
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.rowHeight = 120;
    }
    self.mainTableView.emptyDataSetSource = self;
    self.mainTableView.emptyDataSetDelegate = self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.mainTableView reloadEmptyDataSet];
}

- (void)loadData{
    NSString *key = [NSString stringWithFormat:@"shouchang%@",@(self.type)];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.dataArray = [NSMutableArray arrayWithArray:[user objectForKey:key]];
    [self.mainTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.type == 1){
        HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotTableViewCell" forIndexPath:indexPath];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"imglink"]]];
        cell.titleLabel.text = self.dataArray[indexPath.row][@"title"];
        cell.timeLabel.text = self.dataArray[indexPath.row][@"CTIME"];
        return cell;
    }else if (self.type == 2){
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell" forIndexPath:indexPath];
        [cell.faceImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"image"]]];
        cell.titleLabel.text = self.dataArray[indexPath.row][@"title"];
        return cell;
    }else{
        EquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EquipmentCell" forIndexPath:indexPath];
        NSDictionary *tempDic = self.dataArray[indexPath.row];
        [cell.faceImageView sd_setImageWithURL:[NSURL URLWithString:tempDic[@"imglink_1"]]];
        cell.titleLabel.text = tempDic[@"title"];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        
        if (indexPath.row<[self.dataArray count]) {
            [self.dataArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
            NSString *key = [NSString stringWithFormat:@"shouchang%@",@(self.type)];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:self.dataArray forKey:key];
            [user synchronize];
        }
        
    }
    
}






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.type == 1){
        NSString *url = [NSString stringWithFormat:@"%@&project=badminton&content=0&uid=1537272938806",self.dataArray[indexPath.row][@"urls"]];
        TRWebViewController *webView = [[TRWebViewController alloc] init];
        [webView loadRequest:url withType:4];
        [self.navigationController pushViewController:webView animated:YES];
    }else if (self.type == 2){
        TRWebViewController *web = [[TRWebViewController alloc] init];
        [web loadRequest:self.dataArray[indexPath.row][@"url"] withType:4];
        [self.navigationController pushViewController:web animated:YES];
    }else{
        NSString *url = [NSString stringWithFormat:@"%@&project=badminton&content=0&uid=1537272938806",self.dataArray[indexPath.row][@"urls"]];
        TRWebViewController *webView = [[TRWebViewController alloc] init];
        [webView loadRequest:url withType:4];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_nothing"];
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
