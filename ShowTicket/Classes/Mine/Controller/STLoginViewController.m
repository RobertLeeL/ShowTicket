//
//  STLoginViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/16.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import "STRegisterViewController.h"
#import <FMDB.h>
#import <IQKeyboardManager.h>
#import "UIViewController+showHUD.h"
#import "NSString+check.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kTextFieldWidth [UIScreen mainScreen].bounds.size.width * 0.87
#define kTextFieldHeight 40
#define kTextLeftPadding [UIScreen mainScreen].bounds.size.width * 0.055

#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define kForgetPwdBtnWidth [UIScreen mainScreen].bounds.size.width * 0.3

// 输入框距离顶部的高度
#define kTopHeight

@interface STLoginViewController ()


//2 用户名
@property (nonatomic,strong) UITextField *nameTextField;
//3 密码
@property (nonatomic,strong)UITextField *pwdTextField;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, assign) BOOL exist;

@end

@implementation STLoginViewController
#pragma mark - 懒加载AVPlayer



#pragma mark - 1 viewWillAppear 就进行播放
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.pwdTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.shouldShowToolbarPlaceholder = YES;
    keyboardManager.placeholderFont = [UIFont systemFontOfSize:15];
    
    self.exist = NO;
    [self setupUI];
    
}

#pragma mark - setupUI
- (void)setupUI
{
    UILabel *registerLabel = [[UILabel alloc] init];
    registerLabel.textColor = [UIColor blackColor];
    registerLabel.text = @"账号登录";
    registerLabel.textAlignment = NSTextAlignmentCenter;
    registerLabel.font = [UIFont systemFontOfSize:20];
    registerLabel.frame = CGRectMake(60, 15, kScreenW - 120, 40);
    [self.view addSubview:registerLabel];
    
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    _backButton.frame = CGRectMake(0, 20, 40, 40);
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    // 1 此处做界面
    _nameTextField = [[UITextField alloc]init];
    _nameTextField.placeholder = @"手机号";
    _nameTextField.font = [UIFont systemFontOfSize:16.0f];
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_nameTextField];
    
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(70);
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView1 = [[UIView alloc]init];
    sepView1.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sepView1];
    [sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(1.5);
        make.left.mas_equalTo(_nameTextField.mas_left);
        make.top.mas_equalTo(_nameTextField.mas_bottom);
    }];
    
    //2 此处做界面
    _pwdTextField = [[UITextField alloc]init];
    _pwdTextField.placeholder = @"密码";
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.font = [UIFont systemFontOfSize:16.0f];
    _pwdTextField.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:_pwdTextField];
    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(sepView1.mas_bottom).mas_offset(20);
    }];
    
    //2.1 添加一个分割线
    UIView *sepView2 = [[UIView alloc]init];
    sepView2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sepView2];
    [sepView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(1.5);
        make.left.mas_equalTo(_nameTextField.mas_left);
        make.top.mas_equalTo(_pwdTextField.mas_bottom);
    }];
    
    
    // 3 按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = kRGBColor(24, 154, 204);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 3;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(_nameTextField.mas_left);
        make.top.mas_equalTo(sepView2.mas_bottom).mas_offset(30);
    }];
    
    
    // 4 忘记密码
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPwdBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [forgetPwdBtn setTitleColor:kRGBColor(24, 154, 214) forState:UIControlStateNormal];
    [self.view addSubview:forgetPwdBtn];
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kForgetPwdBtnWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(_nameTextField.mas_left);
        make.top.mas_equalTo(loginBtn.mas_bottom).mas_offset(10);
    }];
    
    
    // 5 新用户注册
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [registBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setTitleColor:kRGBColor(24, 154, 214) forState:UIControlStateNormal];
    [self.view addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kForgetPwdBtnWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.right.mas_equalTo(_nameTextField.mas_right);
        make.top.mas_equalTo(loginBtn.mas_bottom).mas_offset(10);
    }];
    
}


#pragma mark - 所有的点击事件
#pragma mark - 登录按钮的点击
- (void)loginBtnClick
{
    NSString *iphoneNumber = _nameTextField.text;
    NSLog(@"%@",iphoneNumber);
    if (!_nameTextField.text.length && !_pwdTextField.text.length) {
        [self showHUD:@"输入完整的用户信息"];
    } else if (![_nameTextField.text checkPhoneNumer]) {
        [self showHUD:@"输入正确手机号"];
    } else {
//        NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [libDir stringByAppendingString:@"/user.sqlite"];
        NSLog(@"%@",path);
        FMDatabase  *db = [FMDatabase databaseWithPath:path];
        if ([db open]) {
            BOOL success = [db executeUpdate:@"create table if not exists t_user (phoneNumber text not null,userName text not null,age integer,mail text not null,password text not null,male integer);"];
            if (success) {
                NSLog(@"创表成功");
            } else {
                NSLog(@"创表失败");
            }
        }
        FMResultSet *set = [db executeQuery:@"select * from 't_user' where phoneNumber = ?",_nameTextField.text];
        while ([set next]) {
            NSString *iphoneNumber = [set stringForColumn:@"phoneNumber"];
            NSString *userName = [set stringForColumn:@"userName"];
            int age = [set intForColumn:@"age"];
            NSString *mail = [set stringForColumn:@"mail"];
            NSString *password = [set stringForColumn:@"password"];
            int male = [set intForColumn:@"male"];
            
            if ([password isEqualToString:_pwdTextField.text]) {
                self.exist = YES;
//                                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"phoneNumber":@iphoneNumber,@"userName":@userName,@"age":@age,@"mail":@mail,@"password":@password,@"male":@male, nil];
                NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[iphoneNumber,userName,[NSNumber numberWithInt:age],mail,password,[NSNumber numberWithInt:male]] forKeys:@[@"phoneNumber",@"userName",@"age",@"mail",@"password",@"male"]];
                [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"currentUserInfo"];;
                [NSUserDefaults standardUserDefaults];
            } else {
                [self showHUD:@"账号或者密码错误"];
            }
        }
        if (self.exist) {
            [self showHUD:@"登录成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [db close];
    }
}
- (void)registBtnClick
{
    [self presentViewController:[[STRegisterViewController alloc] init] animated:YES completion:nil];
}
- (void)forgetPwdBtnClick
{
    [self showHUD:@"忘记密码我也没办法"];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.pwdTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
