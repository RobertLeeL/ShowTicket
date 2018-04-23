//
//  STRootViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/3/19.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STRootViewController.h"
#import "STUserLocation.h"
#import "STMineViewController.h"
#import "STShowViewController.h"
#import "STVerbViewController.h"
#import "STDiscoveryViewController.h"
#import "STNavigationViewController.h"


@interface STRootViewController ()

@end

@implementation STRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupItems];
    
    [self setupChildViewControlers];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
}

- (void)setupItems {
    // UIControlStateNormal状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 文字大小
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // UIControlStateSelected状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    // 统一给所有的UITabBarItem设置文字属性
    // 只有后面带有UI_APPEARANCE_SELECTOR的属性或方法, 才可以通过appearance对象来统一设置
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)setupChildViewControlers {
    [self setupChildVc:[[STVerbViewController alloc] init] title:@"精选" image:@"icon_tab1_normal" selectedImage:@"icon_tab1_selected"];
    
    [self setupChildVc:[[STShowViewController alloc] init] title:@"演出" image:@"icon_tab2_normal" selectedImage:@"icon_tab2_selected"];
    
    [self setupChildVc:[[STDiscoveryViewController alloc] init] title:@"发现" image:@"icon_tab3_normal" selectedImage:@"icon_tab3_selected"];
    
    [self setupChildVc:[[STMineViewController alloc] init] title:@"我的" image:@"icon_tab4_normal" selectedImage:@"icon_tab4_selected"];
}

- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    // 设置子控制器的tabBarItem
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
