//
//  STShowDetailLocationTableViewCell.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/11.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STShowDetailLocationTableViewCell.h"
#import <Masonry.h>
#import "UIColor+Hex.h"

@interface STShowDetailLocationTableViewCell()

@end

@implementation STShowDetailLocationTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setup];
    return self;
}

- (void)setup {
    _location = [[UILabel alloc] init];
    _location.font = [UIFont systemFontOfSize:16];
    _location.textColor = [UIColor blackColor];
    [self.contentView addSubview:_location];
    
    _detailLocation = [[UILabel alloc] init];
    _detailLocation.font = [UIFont systemFontOfSize:12];
    _detailLocation.textColor = [UIColor grayColor];
    [self.contentView addSubview:_detailLocation];
    
    _locationImage = [[UIImageView alloc] init];
    _locationImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_locationImage];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F4153D"];
    [self.contentView addSubview:line];
    
    [_location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-60);
        make.height.mas_equalTo(20);
    }];
    
    [_detailLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_location.mas_left);
        make.right.mas_equalTo(_location.mas_right);
        make.top.mas_equalTo(_location.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(15);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_location.mas_right).mas_offset(5);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
        make.width.mas_equalTo(0.5);
    }];
    
    [_locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.width.mas_equalTo(40);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
