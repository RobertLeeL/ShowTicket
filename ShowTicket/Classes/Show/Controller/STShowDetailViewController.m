//
//  STShowDetailViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/10.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STShowDetailViewController.h"
#import "STDetailHeadView.h"
#import "UIImage+color.h"
#import "UIColor+Hex.h"
#import <UIImageView+WebCache.h>
#import <objc/runtime.h>
#import "HttpTool.h"
#import "STShowModel.h"
#import <YYModel.h>
#import "STShowDetailModel.h"
#import "STShowDetailLocationTableViewCell.h"

@interface STShowDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) STDetailHeadView *headerView;
@property (nonatomic, strong) UIVisualEffectView *bgView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *verbDataArray;
@property (nonatomic, strong) STShowDetailModel *detailModel;

@end

@implementation STShowDetailViewController

static char kWRStatusBarStyleKey;



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight - 44 ) style:UITableViewStyleGrouped];
//        _tableView.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight - 44 );
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)verbDataArray {
    if (!_verbDataArray) {
        _verbDataArray = [[NSMutableArray alloc] init];
    }
    return _verbDataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavBar];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self getVerbDataArray];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)configNavBar {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 0;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setImage:[UIImage imageNamed:@"find_like"] forState:UIControlStateNormal];
    likeButton.tag = 1;
    [likeButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightOneItem = [[UIBarButtonItem alloc] initWithCustomView:likeButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"icon_share_red_normal"] forState:UIControlStateNormal];
    shareButton.tag = 2;
    [shareButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightTwoItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItems = @[rightTwoItem,rightOneItem];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FFFFFF"] size:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.navigationController.navigationBar.translucent = YES;
    self.title = @"项目详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:0]}];
}

- (void)back:(id)sender {
    UIButton *button = sender;
    if (button.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configUI {
    _topView = [[UIImageView alloc] init];
    _topView.frame = CGRectMake(0, 0, ScreenWidth, 180);
    [_topView sd_setImageWithURL:[NSURL URLWithString:self.model.posterURL]];
    _topView.contentMode = UIViewContentModeScaleToFill;
    _bgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _bgView.frame = CGRectMake(0, 0, ScreenWidth, 180);
    
    [_topView addSubview:_bgView];
    
    _headerView = [[STDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    [_headerView initWithModel:self.model];
    
    [_topView addSubview:_headerView];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = _topView;
    self.tableView.sectionHeaderHeight = 5;
    
}

- (void)getVerbDataArray {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [HttpTool getUrlWithString:[NSString stringWithFormat:@"https://www.tking.cn/showapi/mobile/pub/shows//%@/recommendShows?isSupportSession=1&src=ios&ver=4.1.0",self.model.showOID] parameters:nil success:^(id responseObject) {
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
            [self.verbDataArray addObjectsFromArray:data];
            [_tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        
    }];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [HttpTool getUrlWithString:[NSString stringWithFormat:@"https://www.tking.cn/showapi/mobile/pub/show//%@?client=piaodashi_weixin&isSupportSession=1&src=ios&ver=4.1.0",self.model.showOID] parameters:nil success:^(id responseObject) {
        if (responseObject) {
            //            NSLog(@"%@",responseObject);
            NSDictionary *dict = responseObject[@"result"];
            NSDictionary *array = dict[@"data"];
                STShowDetailModel *cell = [STShowDetailModel yy_modelWithDictionary:array];
            _detailModel = cell;
                if (cell) {
                    [dataArray addObject:cell];
            }
            [self.dataArray addObjectsFromArray:dataArray];
            [_tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 2;
    } else {
        return self.verbDataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70;
        } else {
            return 40;
        }
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.dataArray.count) {
                STShowDetailLocationTableViewCell *cell = [[STShowDetailLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.location.text = _detailModel.venueName;
                cell.detailLocation.text = _detailModel.venueAddress;
                cell.locationImage.image = [UIImage imageNamed:@"tbbuy_location"];
                return cell;
            }
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            cell.imageView.image = [UIImage imageNamed:@"ticklet_parking"];
            cell.textLabel.text = @"快递送票";
            return cell;
        }
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"演出介绍";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"购票提示";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"哈哈";
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f",offsetY);
    if (offsetY > 40) {
        CGFloat alpha = ((offsetY - 40) / 76);
        if (alpha > 1) {
            alpha = 1;
        }
        NSLog(@"%f",alpha);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:alpha]}];
//        [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithWhite:1 alpha:alpha]];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
        
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:alpha] size:CGSizeMake(ScreenWidth, 64)];
         [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:0]}];
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)wr_setStatusBarStyle:(UIStatusBarStyle)style {
    objc_setAssociatedObject(self, &kWRStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
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
