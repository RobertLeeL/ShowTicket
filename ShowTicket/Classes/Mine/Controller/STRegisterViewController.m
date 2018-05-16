//
//  STRegisterViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/16.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STRegisterViewController.h"
#import <Masonry.h>
#import <FMDB.h>
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

@interface STRegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *iphoneNumber;
@property (nonatomic, strong) UITextField *userName;
@property (nonatomic, strong) UITextField *secretString;
@property (nonatomic, strong) UITextField *doubleSecretString;
@property (nonatomic, strong) UITextField *age;
@property (nonatomic, strong) UISegmentedControl *male;
@property (nonatomic, assign) BOOL female;
@property (nonatomic, strong) UITextField *mail;
@property (nonatomic, assign) BOOL existed;

@property (nonatomic, strong) UIButton *backButton;


@end

@implementation STRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.female = YES;
    self.existed = NO;
    [self setupUI];
    // Do any additional setup after loading the view.
    
}

- (void)setupUI {
    
    UILabel *registerLabel = [[UILabel alloc] init];
    registerLabel.textColor = [UIColor blackColor];
    registerLabel.text = @"账号注册";
    registerLabel.textAlignment = NSTextAlignmentCenter;
    registerLabel.font = [UIFont systemFontOfSize:20];
    registerLabel.frame = CGRectMake(60, 15, kScreenW - 120, 40);
    [self.view addSubview:registerLabel];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    _backButton.frame = CGRectMake(0, 20, 40, 40);
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.text = @"手机号：";
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(_backButton.mas_bottom).mas_offset(5);
    }];
    
    _iphoneNumber = [[UITextField alloc]init];
    _iphoneNumber.placeholder = @"手机号";
    _iphoneNumber.font = [UIFont systemFontOfSize:16.0f];
    _iphoneNumber.borderStyle = UITextBorderStyleNone;
    _iphoneNumber.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_iphoneNumber];
    
    [_iphoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(numberLabel.mas_bottom).mas_offset(5);
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView1 = [[UIView alloc]init];
    sepView1.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sepView1];
    [sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_iphoneNumber.mas_width);
        make.height.mas_equalTo(1.5);
        make.left.mas_equalTo(_iphoneNumber.mas_left);
        make.top.mas_equalTo(_iphoneNumber.mas_bottom);
    }];
    
    UILabel *userName = [[UILabel alloc] init];
    userName.text = @"用户名：";
    userName.textColor = [UIColor blackColor];
    userName.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:userName];
    
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(sepView1.mas_bottom).mas_offset(5);
    }];
    
    _userName = [[UITextField alloc]init];
    _userName.placeholder = @"用户名";
    _userName.font = [UIFont systemFontOfSize:16.0f];
    _userName.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:_userName];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(userName.mas_bottom).mas_offset(5);
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView2 = [[UIView alloc]init];
    sepView2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sepView2];
    [sepView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_userName.mas_width);
        make.height.mas_equalTo(1.5);
        make.left.mas_equalTo(_userName.mas_left);
        make.top.mas_equalTo(_userName.mas_bottom);
    }];
    
    UILabel *mail = [[UILabel alloc] init];
    mail.text = @"邮箱：";
    mail.textColor = [UIColor blackColor];
    mail.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:mail];
    
    [mail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(sepView2.mas_bottom).mas_offset(5);
    }];
    
    _mail = [[UITextField alloc]init];
    _mail.placeholder = @"邮箱";
    _mail.font = [UIFont systemFontOfSize:16.0f];
    _mail.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:_mail];
    
    [_mail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(mail.mas_bottom).mas_offset(5);
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView3 = [[UIView alloc]init];
    sepView3.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sepView3];
    [sepView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_mail.mas_width);
        make.height.mas_equalTo(1.5);
        make.left.mas_equalTo(_mail.mas_left);
        make.top.mas_equalTo(_mail.mas_bottom);
    }];
    
   
    
    UILabel *secret = [[UILabel alloc] init];
    secret.text = @"密码：";
    secret.textColor = [UIColor blackColor];
    secret.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:secret];
    
    [secret mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(sepView3.mas_bottom).mas_offset(5);
    }];
    
    _secretString = [[UITextField alloc]init];
    _secretString.placeholder = @"密码";
    _secretString.font = [UIFont systemFontOfSize:16.0f];
    _secretString.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:_secretString];
    
    [_secretString mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(secret.mas_bottom).mas_offset(5);
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView4 = [[UIView alloc]init];
    sepView4.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sepView4];
    [sepView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_secretString.mas_width);
        make.height.mas_equalTo(1.5);
        make.left.mas_equalTo(_secretString.mas_left);
        make.top.mas_equalTo(_secretString.mas_bottom);
    }];
    
    UILabel *duobleSecret = [[UILabel alloc] init];
    duobleSecret.text = @"再次输入密码：";
    duobleSecret.textColor = [UIColor blackColor];
    duobleSecret.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:duobleSecret];
    
    [duobleSecret mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(sepView4.mas_bottom).mas_offset(5);
    }];
    
    _doubleSecretString = [[UITextField alloc]init];
    _doubleSecretString.placeholder = @"再次输入密码";
    _doubleSecretString.font = [UIFont systemFontOfSize:16.0f];
    _doubleSecretString.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:_doubleSecretString];
    
    [_doubleSecretString mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(duobleSecret.mas_bottom).mas_offset(5);
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView5 = [[UIView alloc]init];
    sepView5.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sepView5];
    [sepView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_doubleSecretString.mas_width);
        make.height.mas_equalTo(1.5);
        make.left.mas_equalTo(_doubleSecretString.mas_left);
        make.top.mas_equalTo(_doubleSecretString.mas_bottom);
    }];
    
    UILabel *male = [[UILabel alloc] init];
    male.text = @"性别：";
    male.textColor = [UIColor blackColor];
    male.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:male];
    
    [male mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(sepView5.mas_bottom).mas_offset(5);
    }];
    
    NSArray *maleArray = @[@"男",@"女"];
    _male = [[UISegmentedControl alloc] initWithItems:maleArray];
    _male.selectedSegmentIndex = 0;
    [_male addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_male];
    
    [_male mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.top.mas_equalTo(sepView5.mas_bottom).mas_offset(5);
    }];
    
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.text = @"年龄：";
    ageLabel.textColor = [UIColor blackColor];
    ageLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:ageLabel];
    
    [ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.top.mas_equalTo(_male.mas_bottom).mas_offset(5);
    }];
    
    _age = [[UITextField alloc]init];
    _age.placeholder = @"年龄：";
    _age.keyboardType = UIKeyboardTypeNumberPad;
    _age.font = [UIFont systemFontOfSize:16.0f];
    _age.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:_age];
    
    [_age mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.height.mas_equalTo(kTextFieldHeight);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(_male.mas_bottom).mas_offset(5);
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView6 = [[UIView alloc]init];
    sepView6.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sepView6];
    [sepView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_age.mas_width);
        make.height.mas_equalTo(1.5);
        make.left.mas_equalTo(_age.mas_left);
        make.top.mas_equalTo(_age.mas_bottom);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = kRGBColor(24, 154, 204);
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 3;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(_age.mas_bottom).mas_offset(10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)change:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.female = YES;
    } else {
        self.female = NO;
    }
    NSLog(@"%ld",(long)sender.selectedSegmentIndex);
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginBtnClick {
    if (!(_age.text.length && _iphoneNumber.text.length && _mail.text.length && _userName.text.length && _secretString.text.length && _doubleSecretString.text.length)) {
        [self showHUD:@"请填写完整的信息"];
    } else if (![_secretString.text isEqualToString:_doubleSecretString.text]) {
        [self showHUD:@"请输入两次相同的密码"];
    } else if (![_iphoneNumber.text checkPhoneNumer]) {
        [self showHUD:@"请输入正确手机号"];
    } else if (![_mail.text checkEmail]) {
        [self showHUD:@"请输入正确邮箱"];
    } else {
//        NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//        NSString *path = [docuPath stringByAppendingString:@"user.sqlite"];
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
        } else {
            NSLog(@"数据库open失败");
        }
        int age = [_age.text intValue];
//        int male = _female;
//        BOOL succ = [db executeUpdate:@"insert into 't_user'(phoneNumber,userName,age,mail,password,male)"withArgumentsInArray:@[_iphoneNumber.text,_userName.text,[NSNumber numberWithInt:age],_mail.text,_secretString.text,[NSNumber numberWithBool:_female]]];
        FMResultSet *set = [db executeQuery:@"select * from 't_user' where phoneNumber = ?",_iphoneNumber.text];
        while ([set next]) {
            self.existed = YES;
        }
        
        if (self.existed) {
            [self showHUD:@"用户已存在"];
        } else {
            BOOL result = [db executeUpdateWithFormat:@"insert into 't_user' (phoneNumber,userName,age,mail,password,male) values(%@,%@,%d,%@,%@,%d)",_iphoneNumber.text,_userName.text,age,_mail.text,_secretString.text,_female];
            
            if (result) {
                NSLog(@"插入成功");
                [self showHUD:@"注册成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            } else {
                NSLog(@"插入失败");
                [self showHUD:@"注册失败"];
        }
        }
        [db close];
    }
    
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
