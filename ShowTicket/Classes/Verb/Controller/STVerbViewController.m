//
//  STVerbViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/3/26.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STVerbViewController.h"
#import "UIColor+Hex.h"
#import "UIView+layout.h"
#import "UIImage+color.h"
#import "SelectCityButton.h"
#import "STCalendarViewController.h"
#import "JFCityViewController.h"
#import "STImageScorollView.h"
#import "STVerbTableViewCell.h"
#import "HttpTool.h"
#import "STUserLocation.h"
#import <YYModel.h>
#import "STShowInformation.h"
#import "STBannerInformation.h"

#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height


@interface STVerbViewController ()<UITableViewDelegate,UITableViewDataSource,STVerbTableViewCellDelegate>

@property (nonatomic, strong) STImageScorollView *imageScorollView;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, strong) UITableView *showTableView;

@property (nonatomic, strong) NSMutableArray *bannerDataArray;
@property (nonatomic, strong) NSMutableArray *hotShowDataArray;
@property (nonatomic, strong) NSMutableArray *showDataArray;
@property (nonatomic, strong) NSMutableArray *musicShowDataArray;
@property (nonatomic, strong) NSMutableArray *musicDataArray;
@property (nonatomic, strong) NSMutableArray *verbDataArray;



@end

@implementation STVerbViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.frame = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.frame.size.width, 44);
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self cofigNavagationBar];
    [self getData];
    _imageScorollView = [[STImageScorollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 250) imageList:self.bannerDataArray];
    [self.view addSubview:_imageScorollView];
    _showTableView = [[UITableView alloc] init];
    _showTableView.frame = ScreenBounds;
    _showTableView.delegate = self;
    _showTableView.dataSource = self;
//    _showTableView.tableHeaderView = _imageScorollView;
//    [self.view addSubview:_showTableView];
    // Do any additional setup after loading the view.
}

- (void)cofigNavagationBar {
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
    
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarButton setImage:[UIImage imageNamed:@"calendar2"] forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(calendarShow) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:calendarButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F4153D"] size:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];

}

- (void)getData {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [HttpTool getUrlWithString:@"https://www.tking.cn/showapi/mobile/pub/site/1002/banner/app?isSupportSession=1&siteCityOID=1101&src=ios&timeinterval=1524407554&ver=4.1.0" parameters:nil success:^(id responseObject) {
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
            [self.bannerDataArray addObjectsFromArray:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSMutableArray *posterURLArray = [[NSMutableArray alloc] init];
//                for (STBannerInformation *dict in data) {
//                    NSString *string = dict.posterUrl;
//                    [posterURLArray addObject:string];
//                }
//                _imageScorollView = [[STImageScorollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 250) imageList:posterURLArray];
//                [self.view addSubview:_imageScorollView];
//            });
            _imageScorollView.dataArray = self.bannerDataArray;
            [_imageScorollView reloadImageScrollView];
            [_imageScorollView.scrollView.mainView reloadData];
                    }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
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

- (void)calendarShow {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        STCalendarViewController *calendar = [[STCalendarViewController alloc] init];
        UINavigationController  *navi = [[UINavigationController alloc]initWithRootViewController:calendar];
        [self presentViewController:navi animated:YES completion:^{
        }];
    });
}

- (void)seachShow {
    
}

#pragma mark-TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 4;
//    } else {
//        return 1;
//    }
    return 1;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

@end
