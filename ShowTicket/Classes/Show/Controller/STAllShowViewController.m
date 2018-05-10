//
//  STAllShowViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/10.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STAllShowViewController.h"
#import "STShowViewController.h"
#import "SelectCityButton.h"
#import "UIImage+color.h"
#import "UIColor+Hex.h"
#import "UIView+layout.h"

#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface STAllShowViewController ()

@property (nonatomic, strong) SelectCityButton *cityButton;

@end

@implementation STAllShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    self.menuView.backgroundColor = [UIColor whiteColor];
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

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 9;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"全部";
            break;
        case 1:
            return @"演唱会";
            break;
        case 2:
            return @"话剧歌剧";
            break;
        case 3:
            return @"音乐会";
            break;
        case 4:
            return @"体育赛事";
            break;
        case 5:
            return @"舞蹈芭蕾";
            break;
        case 6:
            return @"儿童亲子";
            break;
        case 7:
            return @"展览休闲";
            break;
        case 8:
            return @"曲艺杂谈";
            break;
        default:
            break;
    }
    return @"none";
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    STShowViewController *vc = [[STShowViewController alloc] init];
    vc.index = index;
    return vc;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 10;
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
