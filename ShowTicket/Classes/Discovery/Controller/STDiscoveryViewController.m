//
//  STDiscoveryViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/3/26.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STDiscoveryViewController.h"
#import "SelectCityButton.h"
#import "UIColor+Hex.h"
#import "UIView+layout.h"
#import "UIImage+color.h"
#import "JFCityViewController.h"
#import <MJRefresh.h>
#import "STDiscoveryTableViewCell.h"
#import <UIImageView+WebCache.h>



#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height


@interface STDiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *headerImages;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation STDiscoveryViewController

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
    [self setupNavbar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = ScreenBounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // Set the callback（一Once you enter the refresh status，then call the action of target，that is call [self loadNewData]）
    
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
    _tableView.mj_header = header;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}

- (void)setupNavbar {
    SelectCityButton *cityBtn = [SelectCityButton buttonWithType:UIButtonTypeCustom];
    if (self.cityName ) {
        [cityBtn setTitle:self.cityName forState:UIControlStateNormal];
    }else {
        [cityBtn setTitle:@"北京" forState:UIControlStateNormal];
    }
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"btn_cityArrow"] forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(selectedCity) forControlEvents:UIControlEventTouchUpInside];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //    self.cityBtn = cityBtn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索明星、演唱会、场馆" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor colorWithHexString:@"#f9f9f9"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"index_search"] forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:[[UIColor colorWithHexString:@"#f3f3f3"] colorWithAlphaComponent:0.6]];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    searchBtn.width = ScreenWidth * 0.7;
    searchBtn.height = 30;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 4;
    [searchBtn addTarget:self action:@selector(seachShow) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchBtn;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F4153D"] size:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedCity {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        JFCityViewController *city = [[JFCityViewController alloc] init];
        city.locationCityName = @"北京";
        UINavigationController  *navi = [[UINavigationController alloc]initWithRootViewController:city];
        [self presentViewController:navi animated:YES completion:^{
        }];
    });
}

- (void)seachShow {
    
}

- (void)loadNewData {
    
}


#pragma mark-TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"discoveryCell";
    STDiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[STDiscoveryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.desLabel.text = self.dataArray[indexPath.row];
    [cell.image sd_setImageWithURL:@"" placeholderImage:@""];
    return cell;
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
