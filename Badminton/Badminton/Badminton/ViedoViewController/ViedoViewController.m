//
//  ViedoViewController.m
//  Badminton
//
//  Created by try-ios on 2018/9/6.
//  Copyright © 2018年 try-ios. All rights reserved.
//

#import "ViedoViewController.h"
#import <UIImageView+WebCache.h>
#import "SQNetWorkCenter.h"
#import "MJRefresh.h"
#import "ViedoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "TRWebViewController.h"

@interface ViedoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (assign, nonatomic) NSInteger page;
@end

@implementation ViedoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat itemWidth = (CGRectGetWidth(self.view.frame) - (32 + 16)) / 2;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 0;
    self.page = 1;
    self.mainCollectionView.collectionViewLayout = layout;
    __weak ViedoViewController *weakSelf = self;
    self.mainCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf handlePageData:weakSelf.page];
    }];
    self.mainCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf handlePageData:weakSelf.page];
    }];
    [self handlePageData:self.page];
}

- (void)handlePageData:(NSInteger)page{
    NSString *url = [NSString stringWithFormat:@"https://app.aiyuke.com/App/api.htm?clientOS=IOS&clientVer=4.9&api=Video.LoadMore&ajax=1&app=1&from_app=ayk&lat=30.546314&lng=104.068152&page=%@&times=0&type=Training",@(page)];
    [SQNetWorkCenter requestDataofUrl:url andParmeters:nil getWithBlock:^(id content, BOOL status) {
        if (page == 1) {
            self.dataSourceArray = [NSMutableArray array];
        }
        NSArray *tempArray = [content[@"msg"][@"list"] copy];
        for (int i = 0; i < tempArray.count; i ++) {
            NSArray *tag = tempArray[i][@"videoPayLabel"];
            if (tag.count > 0) {
                continue;
            }
            [self.dataSourceArray addObject:tempArray[i]];
        }        
        [self.mainCollectionView reloadData];
        [self.mainCollectionView.mj_header endRefreshing];
        [self.mainCollectionView.mj_footer endRefreshing];
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ViedoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ViedoCollectionViewCell" forIndexPath:indexPath];
    [cell.faceImageView sd_setImageWithURL:[NSURL URLWithString:self.dataSourceArray[indexPath.row][@"image"]]];
    cell.titleLabel.text = self.dataSourceArray[indexPath.row][@"title"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TRWebViewController *web = [[TRWebViewController alloc] init];
    web.loadDic = self.dataSourceArray[indexPath.row];
    [web loadRequest:self.dataSourceArray[indexPath.row][@"url"] withType:2];
    [self.navigationController pushViewController:web animated:YES];
    
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
