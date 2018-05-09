//
//  STMineHeaderView.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/9.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STMineHeaderView.h"
#import "UIColor+Hex.h"
#import "UIView+layout.h"

#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface STMineHeaderView ()
@property (weak, nonatomic) UIButton *button;
@property (weak, nonatomic) UIView *bottomView;
@end

@implementation STMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F4153D"];
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *bgView=  [[UIImageView alloc] init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#F4153D"];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"登录/注册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"my_head"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.size = button.currentImage.size;
    [self addSubview:button];
    self.button = button;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIButton *couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [couponBtn setTitle:@"优惠券" forState:UIControlStateNormal];
    [couponBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [couponBtn setImage:[UIImage imageNamed:@"my_coupon"] forState:UIControlStateNormal];
    couponBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    couponBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    couponBtn.width = ScreenWidth / 2;
    couponBtn.height = 50;
    couponBtn.x = 0;
    couponBtn.y = 0;
    [bottomView addSubview:couponBtn];
    
    UIButton *integralBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [integralBtn setTitle:@"我的积分" forState:UIControlStateNormal];
    [integralBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [integralBtn setImage:[UIImage imageNamed:@"my_ntegrals"] forState:UIControlStateNormal];
    integralBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    integralBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    integralBtn.width = ScreenWidth / 2;
    integralBtn.height = 50;
    integralBtn.x = ScreenWidth / 2;
    integralBtn.y = 0;
    [bottomView addSubview:integralBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 0.5, 10, 1, 30)];
    lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [bottomView addSubview:lineView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    self.bgView.y -= ScreenHeight;
    self.bgView.height += ScreenHeight;
    self.button.x = 5;
    self.button.y = 20;
    self.button.width += 100;
    self.bottomView.x = 0;
    self.bottomView.y = self.height - 50;
    self.bottomView.width = ScreenWidth;
    self.bottomView.height = 50;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
