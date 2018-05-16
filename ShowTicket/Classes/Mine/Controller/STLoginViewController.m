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

// 0 容器 scrollView
@property (nonatomic,strong)UIScrollView *contentScrollView;

//2 用户名
@property (nonatomic,strong) UITextField *nameTextField;
//3 密码
@property (nonatomic,strong)UITextField *pwdTextField;

@property (nonatomic, strong) UIButton *backButton;

@end

@implementation STLoginViewController
#pragma mark - 懒加载AVPlayer

#pragma mark - 懒加载 contentScrollView
- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,kScreenW , kScreenH)];
        _contentScrollView.delegate = self;
        _contentScrollView.contentSize = CGSizeMake(kScreenW, kScreenH);
        _contentScrollView.userInteractionEnabled =  YES;
        [self.view addSubview:_contentScrollView];
    }
    
    return _contentScrollView;
}

#pragma mark - 1 viewWillAppear 就进行播放
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

#pragma mark - setupUI
- (void)setupUI
{
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    _backButton.frame = CGRectMake(0, 20, 40, 40);
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:_backButton];
    
    // 1 此处做界面
    _nameTextField = [[UITextField alloc]init];
    _nameTextField.placeholder = @"手机号";
    _nameTextField.font = [UIFont systemFontOfSize:16.0f];
    _nameTextField.borderStyle = UITextBorderStyleNone;
    [self.contentScrollView addSubview:_nameTextField];
    
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.contentScrollView.mas_top).mas_offset(70);
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView1 = [[UIView alloc]init];
    sepView1.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:sepView1];
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
    [self.contentScrollView addSubview:_pwdTextField];
    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(sepView1.mas_bottom).mas_offset(20);
    }];
    
    //2.1 添加一个分割线
    UIView *sepView2 = [[UIView alloc]init];
    sepView2.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:sepView2];
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
    [self.contentScrollView addSubview:loginBtn];
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
    [self.contentScrollView addSubview:forgetPwdBtn];
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
    [self.contentScrollView addSubview:registBtn];
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
    
}
- (void)registBtnClick
{
    
}
- (void)forgetPwdBtnClick
{
    
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
