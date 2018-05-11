//
//  STDetailHeadView.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/11.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STDetailHeadView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface STDetailHeadView ()
@property (nonatomic, strong) STShowModel *model;
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *showName;
@property (nonatomic, strong) UILabel *showDate;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation STDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _effectView.frame = CGRectMake(0, -200, frame.size.width, frame.size.height + 200);
//    [self addSubview:_effectView];
    _bgImage  = [[UIImageView alloc] init];
    _bgImage.frame = CGRectMake(0, -200, frame.size.width, frame.size.height + 200);
    _bgImage.contentMode = UIViewContentModeBottom;
    [self setup];
    return self;
}

- (void)setup {
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _showName = [[UILabel alloc] init];
    _showName.font = [UIFont systemFontOfSize:14];
    _showName.numberOfLines = 2;
    _showName.textColor = [UIColor whiteColor];
    
    _showDate = [[UILabel alloc] init];
    _showDate.font = [UIFont systemFontOfSize:9];
    _showDate.textColor = [UIColor grayColor];
    
    _price = [[UILabel alloc] init];
    _price.textColor = [UIColor whiteColor];
    _price.font = [UIFont systemFontOfSize:14];
    [self addSubview:_imageView];
    [self addSubview:_showName];
    [self addSubview:_showDate];
    [self addSubview:_price];
    self.backgroundColor = [UIColor clearColor];
//    [self sendSubviewToBack:_effectView];
//    [self addSubview:_bgImage];
//    [self sendSubviewToBack:_bgImage];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(90);
    }];
    
    [_showName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageView.mas_right).mas_offset(20);
        make.top.mas_equalTo(_imageView.mas_top);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [_showDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_showName.mas_left);
        make.top.mas_equalTo(_showName.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self.mas_right).mas_offset(10);
        make.height.mas_equalTo(10);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_showName.mas_left);
        make.bottom.mas_equalTo(_imageView.mas_bottom);
        make.right.mas_equalTo(_showDate.mas_right);
        make.height.mas_equalTo(20);
    }];
}

- (void)initWithModel:(STShowModel *)model {
    _model = model;
    if (_model) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.posterURL]];
        _showName.text = _model.showName;
        _showDate.text = _model.showDate;
        _price.text = [NSString stringWithFormat:@"%@元起",_model.minPrice];
//        [_bgImage sd_setImageWithURL:[NSURL URLWithString:_model.posterURL]];    }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
