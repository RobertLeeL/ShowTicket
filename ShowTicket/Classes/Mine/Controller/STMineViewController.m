//
//  STMineViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/3/26.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STMineViewController.h"
#import "STMineHeaderView.h"
#import "UIColor+Hex.h"
#import "UIView+layout.h"
#import "UIBarButtonItem+initItem.h"
#import "STLoginViewController.h"

#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface STMineViewController ()<UITableViewDelegate,UITableViewDataSource,STMineHeaderViewDelegate>
@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *titles;
@property (copy, nonatomic) NSArray *images;
@property (weak, nonatomic) STMineHeaderView *headerView;
@end

@implementation STMineViewController

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@[@"我的订单",@"我的票夹",@"电子钱包"],@[@"我的订阅",@"我的收藏"]];
    }
    return _titles;
}

- (NSArray *)images
{
    if (!_images) {
        _images = @[@[@"mine_dingdan",@"mine_ticket",@"mine_dianziqianbao"],@[@"my_subscribe",@"mine_shoucang"]];
    }
    return _images;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setup];
}

- (void)setup
{
    UIBarButtonItem *item1 = [UIBarButtonItem itemWithImageName:@"my_message" highImageName:@"my" target:self action:@selector(navItemClick:)];
    item1.tag = 0;
    UIBarButtonItem *item2 = [UIBarButtonItem itemWithImageName:@"my_setting" highImageName:@"my" target:self action:@selector(navItemClick:)];
    item2.tag = 1;
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F4153D"];
    self.title = @"我的";
    self.navigationController.navigationBar.translucent = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStyleGrouped];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    STMineHeaderView *headerView = [[STMineHeaderView alloc] init];
    headerView.height = 150;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    self.headerView.delegate = self;
}

- (void)navItemClick:(UIBarButtonItem *)button
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MeViewCellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MeViewCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MeViewCellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    }
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.section][indexPath.row]];
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)clickButtonWithTag:(NSInteger)tag {
    if (tag == 51) {
        [self.headerView.button setTitle:@"你好李龙跃" forState:UIControlStateNormal];
    }if (tag == 49) {
        [self presentViewController:[[STLoginViewController alloc] init] animated:YES completion:nil];
    }
}

@end
