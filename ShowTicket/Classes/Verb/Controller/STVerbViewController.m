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
#import "STShowDetailVerbTableViewCell.h"
#import <MJRefresh.h>
#import "STShowDetailViewController.h"
#import "STSearchShowViewController.h"
#import "STUserLocation.h"

#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height


@interface STVerbViewController ()<UITableViewDelegate,UITableViewDataSource,STVerbTableViewCellDelegate,STImageScrollViewDelegate,STVerbTableViewCellDelegate,STShowDetailVerbTableViewCellDelegate,STUserLocationDelegate,JFCityViewControllerDelegate>

@property (nonatomic, strong) STImageScorollView *imageScorollView;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, strong) UITableView *showTableView;

@property (nonatomic, strong) SelectCityButton *cityBtn;

@property (nonatomic, strong) NSMutableArray *bannerDataArray;
@property (nonatomic, strong) NSMutableArray *hotShowDataArray;
@property (nonatomic, strong) NSMutableArray *showDataArray;
@property (nonatomic, strong) NSMutableArray *musicShowDataArray;
@property (nonatomic, strong) NSMutableArray *musicDataArray;
@property (nonatomic, strong) NSMutableArray *verbDataArray;
@property (nonatomic, strong) NSArray *titleLabelArray;
@property (nonatomic, strong) NSMutableArray *headerImages;



@end

@implementation STVerbViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.frame = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.frame.size.width, 44);
    self.tabBarController.tabBar.hidden = NO;
    [self cofigNavagationBar];
    
}

- (NSMutableArray *)headerImages {
    if (!_headerImages) {
        _headerImages = [[NSMutableArray alloc] init];
    }
    return _headerImages;
}


- (NSMutableArray *)bannerDataArray {
    if (!_bannerDataArray) {
        _bannerDataArray = [[NSMutableArray alloc] init];
    }
    return _bannerDataArray;
}

- (NSMutableArray *)hotShowDataArray {
    if (!_hotShowDataArray) {
        _hotShowDataArray = [[NSMutableArray alloc] init];
    }
    return _hotShowDataArray;
}
- (NSMutableArray *)showDataArray {
    if (!_showDataArray) {
        _showDataArray = [[NSMutableArray alloc] init];
    }
    return _showDataArray;
}
- (NSMutableArray *)musicDataArray {
    if (!_musicDataArray) {
        _musicDataArray = [[NSMutableArray alloc] init];
    }
    return _musicDataArray;
}
- (NSMutableArray *)verbDataArray {
    if (!_verbDataArray) {
        _verbDataArray = [[NSMutableArray alloc] init];
    }
    return _verbDataArray;
}

- (NSMutableArray *)musicShowDataArray {
    if (!_musicShowDataArray) {
        _musicShowDataArray = [[NSMutableArray alloc] init];
    }
    return _musicShowDataArray;
}

- (NSArray *)titleLabelArray {
    if (!_titleLabelArray) {
        _titleLabelArray = @[@"近期热门",@"演唱会",@"话剧歌剧",@"音乐会"];
    }
    return _titleLabelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getData];
    [self getUserLocation];
    _imageScorollView = [[STImageScorollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 250)];
//    [self.view addSubview:_imageScorollView];
    _showTableView = [[UITableView alloc] init];
    _showTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44);
    _showTableView.delegate = self;
    _showTableView.dataSource = self;
    _showTableView.tableHeaderView = _imageScorollView;
    _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    _showTableView.mj_header = header;
    [self.view addSubview:_showTableView];
//     Do any additional setup after loading the view.
}

- (void)cofigNavagationBar {
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
    self.cityBtn = cityBtn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityBtn];
    
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
    
    // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
    dispatch_group_t group = dispatch_group_create();
    //创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSMutableArray *bannerData = [[NSMutableArray alloc] init];
        [HttpTool getUrlWithString:@"https://www.tking.cn/showapi/mobile/pub/site/1002/banner/app?isSupportSession=1&siteCityOID=1101&src=ios&timeinterval=1524407554&ver=4.1.0" parameters:nil success:^(id responseObject) {
            if (responseObject) {
                //            NSLog(@"%@",responseObject);
                NSDictionary *dict = responseObject[@"result"];
                NSArray *array = dict[@"data"];
                for (NSDictionary *dataDict in array) {
                    STBannerInformation *cell = [STBannerInformation yy_modelWithDictionary:dataDict];
                    if (cell) {
                        [bannerData addObject:cell];
                    }
                }
                dispatch_semaphore_signal(semaphore);
                [self.bannerDataArray addObjectsFromArray:bannerData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray *posterURLArray = [[NSMutableArray alloc] init];
                    for (STBannerInformation *dict in bannerData) {
                        NSString *string = dict.posterUrl;
                        [posterURLArray addObject:string];
                    }
                    _imageScorollView.dataArray = self.bannerDataArray;
                    _imageScorollView.imagesURLStrings = posterURLArray.copy;
                });
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSMutableArray *hotShowDataArray = [[NSMutableArray alloc] init];
        [HttpTool getUrlWithString:@"https://www.tking.cn/showapi/mobile/pub/site/1009/hot_show?isSupportSession=1&length=30&offset=0&siteCityOID=3301&src=ios&ver=4.1.0" parameters:nil success:^(id responseObject) {
            if (responseObject) {
                //            NSLog(@"%@",responseObject);
                NSDictionary *dict = responseObject[@"result"];
                NSArray *array = dict[@"data"];
                for (NSDictionary *dataDict in array) {
                    STShowInformation *cell = [STShowInformation yy_modelWithDictionary:dataDict];
                    if (cell) {
                        [hotShowDataArray addObject:cell];
                    }
                }
                dispatch_semaphore_signal(semaphore);
                [self.verbDataArray addObjectsFromArray:hotShowDataArray];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSMutableArray *musicDataArray = [[NSMutableArray alloc] init];
        [HttpTool getUrlWithString:@"https://www.tking.cn/showapi/mobile/pub/site/1009/topMarketingShows?isSupportSession=1&siteCityOID=1101&src=ios&timeinterval=1526057216&ver=4.1.0" parameters:nil success:^(id responseObject) {
            if (responseObject) {
                //            NSLog(@"%@",responseObject);
                NSDictionary *dict = responseObject[@"result"];
                NSDictionary *data = dict[@"data"];
                NSArray *array = data[@"recentShows"];
                for (NSDictionary *dataDict in array) {
                    STShowInformation *cell = [STShowInformation yy_modelWithDictionary:dataDict];
                    if (cell) {
                        [musicDataArray addObject:cell];
                    }
                }
                [self.hotShowDataArray addObjectsFromArray:musicDataArray];
                
                NSMutableArray *allDataArray = [[NSMutableArray alloc] init];
                NSArray *allData = data[@"showTypes"];
                for (NSDictionary *showTypesData in allData) {
                    NSArray *typeData = showTypesData[@"shows"];
                    for (NSDictionary *typeDataDict in typeData) {
                        STShowInformation *cell = [STShowInformation yy_modelWithDictionary:typeDataDict];
                        if (cell) {
                            [allDataArray addObject:cell];
                        }
                    }
                }
                [self.showDataArray addObjectsFromArray:[allDataArray subarrayWithRange:NSMakeRange(0, 10)]];
                [self.musicDataArray addObjectsFromArray:[allDataArray subarrayWithRange:NSMakeRange(9, 10)]];
                [self.musicShowDataArray addObjectsFromArray:[allDataArray subarrayWithRange:NSMakeRange(19, 10)]];
                dispatch_semaphore_signal(semaphore);
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 返回主线程进行界面上的修改
        dispatch_async(dispatch_get_main_queue(), ^{
            [_showTableView reloadData];
        });
    });
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HttpTool getUrlWithString:@"https://www.tking.cn/userdataapi/mobile/keywords?isSupportSession=1&src=ios&ver=4.1.0" parameters:nil success:^(id responseObject) {
            if (responseObject) {
                NSDictionary *dict = responseObject[@"result"];
                NSArray *data = dict[@"data"];
                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dataDict in data) {
                    NSString *keyWord = dataDict[@"keyword"];
                    [dataArray addObject:keyWord];
                }
                [[NSUserDefaults standardUserDefaults] setValue:dataArray.copy forKey:@"hotCityName"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        } failure:^(NSError *error) {
            
        }];
    });
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

- (void)calendarShow {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        STCalendarViewController *calendar = [[STCalendarViewController alloc] init];
        UINavigationController  *navi = [[UINavigationController alloc]initWithRootViewController:calendar];
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

#pragma mark-TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 230;
    } else {
        return self.verbDataArray.count ? 30 + self.verbDataArray.count * 150 : 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellID = @"verbCell3";
        STVerbTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[STVerbTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.typeLabel.text = self.titleLabelArray[indexPath.row];
            cell.indexPath = indexPath;
            cell.dataArray = self.hotShowDataArray;
            cell.delegate = self;
            [cell.collectionView reloadData];
            return cell;
        } else if (indexPath.row == 1) {
            cell.typeLabel.text = self.titleLabelArray[indexPath.row];
            cell.indexPath = indexPath;
            cell.dataArray = self.showDataArray;
            cell.delegate = self;
            [cell.collectionView reloadData];
            return cell;
        } else if (indexPath.row == 2) {
            cell.typeLabel.text = self.titleLabelArray[indexPath.row];
            cell.indexPath = indexPath;
            cell.dataArray = self.musicDataArray;
            cell.delegate = self;
            [cell.collectionView reloadData];
            return cell;
        } else if (indexPath.row == 3) {
            cell.typeLabel.text = self.titleLabelArray[indexPath.row];
            cell.indexPath = indexPath;
            cell.dataArray = self.musicShowDataArray;
            cell.delegate = self;
            [cell.collectionView reloadData];
            return cell;
        }
    } else {
        STShowDetailVerbTableViewCell *cell = [[STShowDetailVerbTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"verbDetailCell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.dataArray = self.verbDataArray;
        [cell.tableView reloadData];
        return cell;
    }
    return nil;
}

- (void)loadNewData {
    [self.hotShowDataArray removeAllObjects];
    [self.showDataArray removeAllObjects];
    [self.musicShowDataArray removeAllObjects];
    [self.musicDataArray removeAllObjects];
    [self.verbDataArray removeAllObjects];
    [self.bannerDataArray removeAllObjects];
    [self getData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_showTableView.mj_header endRefreshing];
    });
}

#pragma mark-各种delegate
//STVerbTableViewCellDelegate,STImageScrollViewDelegate,STVerbTableViewCellDelegate,STShowDetailVerbTableViewCellDelegate

- (void)didSelctedCellIndex:(NSInteger)index {
    STShowDetailViewController *vc = [[STShowDetailViewController alloc] init];
    vc.model = self.verbDataArray[index];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)CustomCollection:(UICollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath model:(STShowInformation *)model {
    STShowDetailViewController *vc = [[STShowDetailViewController alloc] init];
    vc.model = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击查看更多按钮
- (void)didSelectMoreButtonAtIndexPath:(NSIndexPath *)indexPath {
    
}


//选择上面的8个按钮
- (void)didSelectedTitleButtonIndex:(NSInteger)index {
    
}

//选择banner时
- (void)didsSelectedImageIndex:(NSInteger)index {
    NSLog(@"%d",index);
}

- (void)cityName:(NSString *)name {
    self.cityName = name;
    [self.cityBtn setTitle:name forState:UIControlStateNormal];
    [self loadNewData];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"selectCityName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)getUserLocation {
    STUserLocation *userlocation = [STUserLocation shareInstance];
    userlocation.delegate = self;
    [userlocation getUserLocation:^(double lat, double lon, NSString *cityName) {
                NSLog(@"%@",cityName);
        NSString *selectCityName = [[NSUserDefaults standardUserDefaults]stringForKey:@"selectCityName"];
        if (![cityName isEqualToString:selectCityName]) {
            [self showAlertView:cityName];
        }
        [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"locationCityName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

- (void)showAlertView:(NSString *)cityName {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"当前定位城市为%@,是否切换",cityName] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cityName = cityName;
        [self.cityBtn setTitle:cityName forState:UIControlStateNormal];
        [self loadNewData];
        [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"selectCityName"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }];
    UIAlertAction *canlecdButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:canlecdButton];
    [alertView addAction:confirmButton];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)getLocationAuthorityDenied {
    [self alertViewWithMessage];
}

- (void)alertViewWithMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"请在系统设置中开启服务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmButton = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //进入系统设置页面，APP本身的权限管理页面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *canlecdButton = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:canlecdButton];
    [alertView addAction:confirmButton];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
}

- (void)dealloc {
    NSLog(@"StVerbViewController dealloc");
}

@end
