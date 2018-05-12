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
#import "HttpTool.h"
#import "STBannerInformation.h"
#import <YYModel.h>
#import "STWebViewController.h"
#import "STAllShowViewController.h"
#import "STSearchShowViewController.h"
#import "SelectCityButton.h"



#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height


@interface STDiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource,JFCityViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *headerImages;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, strong) SelectCityButton *cityButton;

@end

@implementation STDiscoveryViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavbar];
}

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
    
    [self getData];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
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
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    _tableView.mj_header = header;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}

- (void)getData {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [HttpTool getUrlWithString:@"https://www.tking.cn/showapi/mobile/pub/site/1002/discovery?isSupportSession=1&length=10&offset=0&siteCityOID=1101&src=ios&timeinterval=1521381243&ver=4.1.0" parameters:nil success:^(id responseObject) {
        if (responseObject) {
            //            NSLog(@"%@",responseObject);
            NSDictionary *dict = responseObject[@"result"];
            NSArray *array = dict[@"data"];
            for (NSDictionary *dataDict in array) {
                STBannerInformation *cell = [STBannerInformation yy_modelWithDictionary:dataDict];
                if (cell) {
                    [data addObject:cell];
                }
            }
            [self.dataArray addObjectsFromArray:data];
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)setupNavbar {
    SelectCityButton *cityBtn = [SelectCityButton buttonWithType:UIButtonTypeCustom];
    NSString *cityName = [[NSUserDefaults standardUserDefaults]stringForKey:@"selectCityName"];
    if (![self.cityName isEqualToString:cityName]) {
        self.cityName = cityName;
        [self loadNewData];
    }
    [cityBtn setTitle:cityName forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"btn_cityArrow"] forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(selectedCity) forControlEvents:UIControlEventTouchUpInside];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.cityButton = cityBtn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityButton];
    
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
        city.locationCityName = [[NSUserDefaults standardUserDefaults] stringForKey:@"locationCityName"];
        city.delegate = self;
        UINavigationController  *navi = [[UINavigationController alloc]initWithRootViewController:city];
        [self presentViewController:navi animated:YES completion:^{
        }];
    });
}
- (void)seachShow {
    STSearchShowViewController *vc = [[STSearchShowViewController alloc] init];
    UINavigationController  *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:^{
    }];
}

- (void)loadNewData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView.mj_header endRefreshing];
    });
}


#pragma mark-TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170 * ScreenWidth / 375 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"discoveryCell";
    STDiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[STDiscoveryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    STBannerInformation *model = self.dataArray[indexPath.row];
    cell.desLabel.text = model.description;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.posterUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STBannerInformation *model = self.dataArray[indexPath.row];
    STWebViewController *webVC = [[STWebViewController alloc] init];
    webVC.url = model.bannerUrl;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)cityName:(NSString *)name {
    self.cityName = name;
    [self.cityButton setTitle:name forState:UIControlStateNormal];
    [self loadNewData];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"selectCityName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
