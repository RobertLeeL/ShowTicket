//
//  STShowDetailViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/10.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STShowDetailViewController.h"
#import "STStretchableTableHeaderView.h"
#import "STDetailHeadView.h"
#import "STDetailNavBarView.h"

@interface STShowDetailViewController ()<UITableViewDelegate,UITableViewDataSource,STDetailNavBarViewDelegate>

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) STDetailHeadView *headerView;
@property (nonatomic, strong) STStretchableTableHeaderView *stretchableTableHeaderView;
@property (nonatomic, strong) STDetailNavBarView *detailNavView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *verbDataArray;

@end

@implementation STShowDetailViewController

- (STDetailNavBarView *)detailNavView {
    if (!_detailNavView) {
        _detailNavView = [[STDetailNavBarView alloc] init];
        _detailNavView.delegate = self;
        _detailNavView.st_alpha = 0;
#pragma mark -TODO 适配iPhone X
        _detailNavView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    }
    return _detailNavView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)configUI {
    self.title = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.detailNavView];
    
    _headerView = [[STDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    [_headerView initWithModel:self.model];
    _stretchableTableHeaderView = [[STStretchableTableHeaderView alloc] init];
    [self.view addSubview:self.tableView];
    [_stretchableTableHeaderView stretchHeaderForTableView:self.tableView withView:_headerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- STDetailNavBarViewDelegate
- (void)userPagNavBar:(STDetailNavBarView *)navBar didClickButton:(STDetailButtonType)buttonType {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"哈哈";
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //下拉放大 必须实现
    [_stretchableTableHeaderView scrollViewDidScroll:scrollView];
    
    //计算导航栏的透明度
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = ScreenWidth  / 1.7 - 64;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    NSLog(@"alpha--%f",alpha);
    self.detailNavView.st_alpha = alpha;
    
    
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
