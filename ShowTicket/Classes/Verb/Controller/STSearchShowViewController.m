//
//  STSearchShowViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/12.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STSearchShowViewController.h"
#import "STSearchHotView.h"
#import "STSearchResultView.h"
#import "STSearchNavBarView.h"
#import "common_define.h"
#import "HttpTool.h"
#import "STShowModel.h"
#import <YYModel.h>
#import "STShowDetailViewController.h"
#import <YTKKeyValueStore.h>
#import "UIViewController+showHUD.h"

typedef NS_ENUM(NSUInteger, ViewDisplayType) {
    ViewDisplayHistoryTableViewType,     //显示历史搜索
    ViewDisplayResultViewType,           //显示结果
    ViewDisplayDataBlankType             //数据为空
};

@interface STSearchShowViewController ()<STSearchResultViewDelegate>
@property (nonatomic, strong) STSearchResultView *resultView;
@property (nonatomic, strong) STSearchNavBarView *navbarView;
@property (nonatomic, strong) STSearchHotView *hotView;
@property (nonatomic, strong) STSearchResultView *historyView;

@property (nonatomic, strong) NSMutableArray *historyData;
@property (nonatomic, strong) NSMutableArray *resultData;
@property (nonatomic, strong) NSMutableArray *hotData;

@property (nonatomic, assign) ViewDisplayType viewDisplayType;

@end

@implementation STSearchShowViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (STSearchNavBarView *)navbarView
{
    if (!_navbarView) {
        __weak typeof(self) weakSelf = self;
        _navbarView = [[STSearchNavBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CJ_StatusBarAndNavigationBarHeight) beginEditBlock:^(UISearchBar *searchBar) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf stopSearchAction];
        } clickSearchBlock:^(UISearchBar *searchBar) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf saveHistoryKeyWord:searchBar.text];
        }];
        _navbarView.backgroundColor = [UIColor whiteColor];
        _navbarView.clickCancelBlock = ^(){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf backToSuperView];
        };
        //开启联想搜索
        //        _navigationBar.tfdDidChangedBlock = ^(NSString *key) {
        //            __strong typeof(weakSelf) strongSelf = weakSelf;
        //            if (![key isEqualToString:@""]) {
        //                [strongSelf loadResultData:key];
        //            } else {
        //                [strongSelf stopSearchAction];
        //            }
        //        };
    }
    return _navbarView;
}

//历史搜索列表
- (STSearchResultView *)historyView
{
    if (!_historyView) {
        _historyView = [[STSearchResultView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbarView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CJ_StatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        _historyView.type = @"0";
        _historyView.backgroundColor = [UIColor whiteColor];
        _historyView.separatorColor = UIColorHex(0xf0f0f0);
        _historyView.rowHeight = 44;
        _historyView.tableHeaderView = self.hotView;
        __weak typeof(self) weakSelf = self;
        _historyView.clickResultBlock = ^(NSString *key){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.navbarView.searchBar.text = key;
            [strongSelf loadResultData:key];
        };
        
        _historyView.clickDeleteBlock = ^(){
            __strong typeof(weakSelf)  strongSelf = weakSelf;
            [strongSelf deleteHistoryData];
        };
    }
    
    return _historyView;
}

//搜索结果列表
- (STSearchResultView *)resultView {
    if (!_resultView) {
        _resultView = [[STSearchResultView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbarView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CJ_StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _resultView.backgroundColor = [UIColor whiteColor];
        _resultView.separatorColor = UIColorHex(0xf0f0f0);
        _resultView.type = @"1";
        _resultView.myDelegate = self;
        _resultView.rowHeight = 150;
        
    }
    return _resultView;
}

//热门视图搜索
- (STSearchHotView *)hotView {
    if (!_hotView) {
        __weak typeof(self) weakSelf = self;
        _hotView = [[STSearchHotView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) tagColor:kSearchBarTFDColor tagBlock:^(NSString *key) {
            NSLog(@"点击热搜%@",key);
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf saveHistoryKeyWord:key];
        }];
        _hotView.hotKeyArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotCityName"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    return _hotView;
}

//历史搜索数据源
- (NSMutableArray *)historyData
{
    if (!_historyData) {
        _historyData = [[NSMutableArray alloc] init];
    }
    return _historyData;
}
//搜索结果数据源
- (NSMutableArray *)resultData {
    if (!_resultData) {
        _resultData = [[NSMutableArray alloc] init];;
    }
    return _resultData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
    // Do any additional setup after loading the view.
}

- (void)creatView {
    
    [self.view addSubview:self.navbarView];
    [self.view addSubview:self.historyView];
    [self.view addSubview:self.resultView];
    
    [self.navbarView.searchBar becomeFirstResponder];
    
    //加载历史
    [self loadSearchHistoryData];
}

- (void)loadSearchHistoryData
{
    NSArray *originData = [[NSUserDefaults standardUserDefaults] objectForKey:kHistroySearchData];
    
    if (originData.count > 0) {
        [self.historyData addObjectsFromArray:originData];
    }
    [self.historyView.sourceData removeAllObjects];
    [self.historyView.sourceData addObjectsFromArray:self.historyData];
    [self.historyView reloadData];
    self.viewDisplayType = ViewDisplayHistoryTableViewType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 切换显示的view
 */
- (void)setViewDisplayType:(ViewDisplayType)viewDisplayType
{
    _viewDisplayType = viewDisplayType;
    switch (viewDisplayType) {
        case ViewDisplayHistoryTableViewType:
            //显示历史搜索
            self.resultView.hidden = YES;
            self.historyView.hidden = NO;
            [self.view bringSubviewToFront:self.historyView];
            self.historyView.userInteractionEnabled = YES;
            break;
        case ViewDisplayResultViewType:
            //显示搜索结果
            self.historyView.hidden = YES;
            self.resultView.hidden = NO;
            [self.view bringSubviewToFront:self.resultView];
            break;
        default:
            break;
    }
}

//点击清除按钮 || 呼出键盘
- (void)stopSearchAction
{
    self.viewDisplayType = ViewDisplayHistoryTableViewType;
    [self.historyView.sourceData removeAllObjects];
    [self.historyView.sourceData addObjectsFromArray:self.historyData];
    [self.historyView reloadData];
    
}

- (void)saveHistoryKeyWord:(NSString *)keyword
{
    NSString *searchKey = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    if ([searchKey length] == 0) return;
    
    if ([self.historyData containsObject:searchKey]) {
        //如果之前存在，则排序置顶
        [self.historyData removeObject:searchKey];
        [self.historyData insertObject:searchKey atIndex:0];
    } else {
        //如果之前不存在，则插入置顶
        [self.historyData insertObject:searchKey atIndex:0];
    }
    
    //保存最大数量
    if (self.historyData.count > kMaxHistroyNum) {
        [self.historyData removeLastObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.historyData forKey:kHistroySearchData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.historyView.sourceData removeAllObjects];
    [self.historyView.sourceData addObjectsFromArray:self.historyData];
    [self.historyView reloadData];
    
    self.historyView.userInteractionEnabled = NO;
    
    self.navbarView.searchBar.text = keyword;
    [self loadResultData:keyword];
}

#pragma mark -- Data
- (void)loadResultData:(NSString *)key {
    
    self.viewDisplayType = ViewDisplayResultViewType;
    
    /*****模拟请求*******/
    [self.resultData removeAllObjects];
    
    NSString *selectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectCityName"];
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"citiesOID.db"];
    NSString *tableName = @"cities_table";
    [store createTableWithName:tableName];
    NSString *string = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *cityOID = [store getStringById:selectName fromTable:tableName];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [HttpTool getUrlWithString:[NSString stringWithFormat:@"https://www.tking.cn/showapi/mobile/pub/active_show?isSupportSession=1&key_words=%@&length=10&locationCityOID=%@&offset=0&seq=desc&siteCityOID=%@&siteOID=1009&sorting=weight&src=ios&ver=4.1.0",string,cityOID,cityOID] parameters:nil success:^(id responseObject) {
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
            [self.resultData addObjectsFromArray:data];
            self.resultView.userInteractionEnabled = YES;
            [self.resultView.sourceData removeAllObjects];
            self.resultView.sourceData = self.resultData;
            [self.resultView reloadData];
            
            if (!self.resultData.count) {
                [self showHUD:@"无搜索结果"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    if (!self.navbarView.openAssociativeSearch) {
        [self.navbarView.searchBar resignFirstResponder];
    }
}

#pragma mark -- Action
- (void)backToSuperView {
    [self.navbarView.searchBar resignFirstResponder];
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/**
 *  清除搜索记录
 */
- (void)deleteHistoryData
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:deleteTip message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.historyData removeAllObjects];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.historyData forKey:kHistroySearchData];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.historyView.sourceData removeAllObjects];
        [self.historyView.sourceData addObjectsFromArray:self.historyData];
        [self.historyView reloadData];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)didSelectedTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    STShowDetailViewController *vc = [[STShowDetailViewController alloc] init];
    vc.model = self.resultData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
