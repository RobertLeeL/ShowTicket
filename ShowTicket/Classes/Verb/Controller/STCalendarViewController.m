//
//  STCalendarViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/7.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STCalendarViewController.h"
#import <JTCalendar.h>
#import <Masonry.h>
#import <sys/utsname.h>
#import "UIView+layout.h"
#import "HttpTool.h"
#import "STShowTableViewCell.h"
#import <YYModel.h>
#import "STShowInformation.h"
#import "UIViewController+showHUD.h"
#import <MJRefresh.h>
#import "STShowDetailViewController.h"

#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface STCalendarViewController ()<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
}

@property (nonatomic, strong) UITableView *showTableView;
@property (nonatomic, strong) JTCalendarManager *calendarManager;
@property (nonatomic, strong) JTHorizontalCalendarView *calendarContentView;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headerImages;

@end

@implementation STCalendarViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (NSMutableArray *)headerImages {
    if (!_headerImages) {
        _headerImages = [[NSMutableArray alloc] init];
    }
    return _headerImages;
}

- (UITableView *)showTableView {
    if (!_showTableView) {
        _showTableView = [[UITableView alloc] init];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
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
        _showTableView.backgroundColor = [UIColor whiteColor];
    }
    return _showTableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    _calendarManager = [[JTCalendarManager alloc] init];
    _calendarManager.delegate = self;
    [self createMinAndMaxDate];
    
//    _calendarContentView.frame = CGRectMake(0, 100, ScreenWidth, 200);
    
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM yyyy";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    NSDate *date = _calendarManager.date;
    _monthLabel.text = [dateFormatter stringFromDate:date];
    
    
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewData {
    [self getData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_showTableView.mj_header endRefreshing];
    });
}

- (void)getData {
    [self.dataArray removeAllObjects];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [HttpTool getUrlWithString:@"https://www.tking.cn/showapi/mobile/pub/site/1009/calendarShow?fromDate=1526054400000&isSupportSession=1&length=10&offset=0&siteCityOID=1101&src=ios&ver=4.1.0" parameters:nil success:^(id responseObject) {
        if (responseObject) {
            //            NSLog(@"%@",responseObject);
            NSDictionary *dict = responseObject[@"result"];
            NSArray *array = dict[@"data"];
            for (NSDictionary *dataDict in array) {
                STShowInformation *cell = [STShowInformation yy_modelWithDictionary:dataDict];
                if (cell) {
                    [data addObject:cell];
                }
            }
            [self.dataArray addObjectsFromArray:data];
            [_showTableView reloadData];
            if (!self.dataArray.count) {
                [self showHUD:@"该日期无演出"];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)configUI {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    CGFloat safeHeight = 0;
//    if ([[self iphoneType] isEqualToString:@"iPhone X"]) {
//        safeHeight = 24;
//    }
    if ([[self iphoneType] isEqualToString:@"iPhone X"]) {
        safeHeight = 24;
    }
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(5);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(safeHeight + 20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    
    _monthLabel = [[UILabel alloc] init];
    _monthLabel.font = [UIFont systemFontOfSize:18];
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_monthLabel];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton.mas_right).mas_offset(30);
        make.right.equalTo(self.view.mas_right).mas_offset(-70);
        make.top.equalTo(self.view.mas_top).mas_offset(safeHeight + 20);
        make.height.equalTo(backButton.mas_height);
    }];
    
    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    _calendarContentView = [[JTHorizontalCalendarView alloc] init];
    _calendarContentView.backgroundColor = [UIColor whiteColor];
    _calendarContentView.bounces = NO;
//    _calendarContentView.frame = CGRectMake(0, self.monthLabel.y + self.monthLabel.height + 10, ScreenWidth, 150);
    [self.view addSubview:_calendarContentView];
    [_calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(200);
    }];
    
    [self.view addSubview:self.showTableView];
    
    [_showTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_calendarContentView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
}

- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    _dateSelected = [NSDate date];
    
    // Min date will be 0 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:0];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:6];
}

#pragma mark-JtCanlendarDelegate

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
    dayView.hidden = NO;
    
    // Other month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        dayView.textLabel.text = @"今天";
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }else if ([_calendarManager.dateHelper date:_todayDate isEqualOrAfter:dayView.date]) {
        dayView.userInteractionEnabled = NO;
        dayView.textLabel.textColor = [UIColor grayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
//        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    
    
    // Load the previous or next page if touch a day from another month
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM yyyy";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    NSDate *date = calendar.date;
    _monthLabel.text = [dateFormatter stringFromDate:date];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM yyyy";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    NSDate *date = calendar.date;
    _monthLabel.text = [dateFormatter stringFromDate:date];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"calendarCell";
    STShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[STShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STShowDetailViewController *vc = [[STShowDetailViewController alloc] init];
    vc.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"%f",offsetY);
//    if (offsetY > 0) {
//        _calendarManager.settings.weekModeEnabled = YES;
//        [_calendarManager reload];
//        [_calendarContentView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(55);
//        }];
//        [self.view layoutIfNeeded];
//    } else {
//        _calendarManager.settings.weekModeEnabled = NO;
//        [_calendarManager reload];
//        [_calendarContentView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(200);
//        }];
//        [self.view layoutIfNeeded];
//    }
//}


- (NSString*)iphoneType {
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
    
}

@end
