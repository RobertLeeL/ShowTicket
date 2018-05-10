//
//  STWebViewController.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/10.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STWebViewController.h"
#import "UIColor+Hex.h"
#import "UIImage+color.h"

#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface STWebViewController ()<UIWebViewDelegate>

@end

@implementation STWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup
{
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:@"#F4153D"]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString *htmlTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.title = htmlTitle;
    self.title = @"发现专题";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"] size:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"]}];
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
