//
//  STVerbCollectionViewCell.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/9.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STVerbCollectionViewCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface STVerbCollectionViewCell ()

@property (nonatomic, strong) STShowInformation *model;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *showName;
@property (nonatomic, strong) UILabel *showDate;
@property (nonatomic, strong) UILabel *price;

@end

@implementation STVerbCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup {
    _image = [[UIImageView alloc] init];
    _showName = [[UILabel alloc] init];
    _showName.textColor = [UIColor blackColor];
    _showDate = [[UILabel alloc] init];
    _price = [[UILabel alloc] init];
    
    [self.contentView addSubview:_image];
    [self.contentView addSubview:_showName];
    [self.contentView addSubview:_showDate];
    [self.contentView addSubview:_price];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(100);
    }];
    
    [_showName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_image.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(_image.mas_left);
        make.right.mas_equalTo(_image.mas_right);
        make.height.mas_offset(40);
    }];
    
    [_showDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_showName.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(_showName.mas_left);
        make.right.mas_equalTo(_showName.mas_right);
        make.height.mas_offset(10);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_showDate.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(_showDate.mas_left);
        make.right.mas_equalTo(_showDate.mas_right);
        make.height.mas_offset(15);
    }];
}

- (void)initWithModel:(STShowInformation *)model {
    _model = model;
    if (_model) {
        NSURL *url = [NSURL URLWithString:_model.posterURL];
        [_image sd_setImageWithURL:url];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        
        _showName.text = model.showName;
        _showName.numberOfLines = 2;
        _showName.font = [UIFont systemFontOfSize:12];
        
        _showDate.text = model.showDate;
        _showDate.font = [UIFont systemFontOfSize:9];
        
        _price.text = [NSString stringWithFormat:@"%@元起",model.minPrice];
        _price.textColor = [UIColor redColor];
        _price.font = [UIFont systemFontOfSize:10];
    }
}

@end
