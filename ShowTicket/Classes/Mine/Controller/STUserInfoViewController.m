//
//  STUserInfoViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/17.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STUserInfoViewController.h"

@interface STUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation STUserInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.frame = self.view.bounds;
    [self.view addSubview:_tableView];
    
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarButton setTitle:@"注销" forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(calendarShow) forControlEvents:UIControlEventTouchUpInside];
    [calendarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:calendarButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentUserInfo"];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userInfoCell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"用户名:    %@",dict[@"userName"]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"手机号码:   %@",dict[@"phoneNumber"]];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"邮箱:     %@",dict[@"mail"]];
            break;
        case 3:
            if (dict[@"male"]) {
                cell.textLabel.text = @"性别:     男";
            }else {
                cell.textLabel.text = @"性别:     女";
            }
            break;
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"年龄:     %@",dict[@"age"]];
            break;
        default:
            break;
    }
    return cell;
}

- (void)calendarShow {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"currentUserInfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"canceldUser" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
