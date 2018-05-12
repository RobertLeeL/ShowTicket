//
//  STShowViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/3/26.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STShowViewController.h"
#import "SelectCityButton.h"
#import "UIImage+color.h"
#import "UIColor+Hex.h"
#import "UIView+layout.h"
#import <MJRefresh.h>
#import "HttpTool.h"
#import <YYModel.h>
#import "STShowModel.h"
#import "STShowTableViewCell.h"
#import "STShowDetailViewController.h"
#import <YTKKeyValueStore.h>
#import "STDataBase.h"

#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface STShowViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headerImages;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation STShowViewController

- (NSMutableArray *)headerImages {
    if (!_headerImages) {
        _headerImages = [[NSMutableArray alloc] init];
    }
    return _headerImages;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [STDataBase shareInstance];
    self.view.backgroundColor = [UIColor whiteColor];
    _offset = 0;
    [self getData];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 128);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    for (int i = 1;i < 14; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pull_refresh_logo_%d",i]];
        [self.headerImages addObject:image];
    }
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // Set the ordinary state of animated images
    [header setImages:self.headerImages forState:MJRefreshStateIdle];
    // Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    [header setImages:self.headerImages forState:MJRefreshStatePulling];
    // Set the refreshing state of animated images
    [header setImages:self.headerImages forState:MJRefreshStateRefreshing];
    // Set header
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    _tableView.mj_header = header;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view.
}

- (void)getMoreData {
    _offset += 10;
    [self getData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView.mj_footer endRefreshing];
    });
}

- (void)getData {
    
    NSString *selectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectCityName"];
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"citiesOID.db"];
    NSString *tableName = @"cities_table";
    [store createTableWithName:tableName];
    
    NSString *cityOID = [store getStringById:selectName fromTable:tableName];
    
    NSString *time = [self getCurrentTimeInterVal];
    
    NSInteger typeNumber = 0;
    switch (self.index) {
        case 1:
            typeNumber = 1;
            break;
        case 8:
            typeNumber = 4;
            break;
        case 2:
            typeNumber = 3;
            break;
        case 3:
            typeNumber = 2;
            break;
        case 4:
            typeNumber = 6;
            break;
        case 5:
            typeNumber = 5;
            break;
        case 6:
            typeNumber = 9;
            break;
        case 7:
            typeNumber = 7;
            break;
        default:
            typeNumber = 0;
            break;
    }
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    if(typeNumber == 0) {
        [HttpTool getUrlWithString:[NSString stringWithFormat:@"https://www.tking.cn/showapi/mobile/pub/site/1009/active_show?isSupportSession=1&length=10&locationCityOID=%@&offset=%ld&seq=desc&siteCityOID=%@&sorting=weight&src=ios&ver=4.1.0",cityOID,(long)_offset,cityOID] parameters:nil success:^(id responseObject) {
            if (responseObject) {
                //            NSLog(@"%@",responseObject);
                NSDictionary *dict = responseObject[@"result"];
                NSArray *array = dict[@"data"];
                for (NSDictionary *dataDict in array) {
                    STShowModel *cell = [STShowModel yy_modelWithDictionary:dataDict];
                    if (cell) {
                        [data addObject:cell];
                    }
                }
                [self.dataArray addObjectsFromArray:data];
                [_tableView reloadData];
                
            }
        } failure:^(NSError *error) {
            
        }];

    } else {
        [HttpTool getUrlWithString:[NSString stringWithFormat:@"https://www.tking.cn/showapi/mobile/pub/site/1009/active_show?isSupportSession=1&length=10&locationCityOID=%@&offset=%ld&seq=desc&siteCityOID=%@&sorting=weight&src=ios&type=%ld&ver=4.1.0",cityOID,(long)_offset,cityOID,(long)typeNumber] parameters:nil success:^(id responseObject) {
            if (responseObject) {
                //            NSLog(@"%@",responseObject);
                NSDictionary *dict = responseObject[@"result"];
                NSArray *array = dict[@"data"];
                for (NSDictionary *dataDict in array) {
                    STShowModel *cell = [STShowModel yy_modelWithDictionary:dataDict];
                    if (cell) {
                        [data addObject:cell];
                    }
                }
                [self.dataArray addObjectsFromArray:data];
                [_tableView reloadData];
                
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)loadNewData {
    _offset = 0;
    [self.dataArray removeAllObjects];
    [self getData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView.mj_header endRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"showCell";
    STShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[STShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STShowDetailViewController *vc = [[STShowDetailViewController alloc] init];
    vc.model = self.dataArray[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)getCurrentTimeInterVal {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

@end
