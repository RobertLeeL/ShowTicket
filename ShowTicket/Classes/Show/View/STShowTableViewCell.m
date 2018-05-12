//
//  STShowTableViewCell.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/10.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STShowTableViewCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "UIColor+Hex.h"

@interface STShowTableViewCell ()
@property (nonatomic, strong) STShowModel *model;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UILabel *showNameLabel;
@property (nonatomic, strong) UILabel *showDateLabel;
@property (nonatomic, strong) UILabel *showLocation;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UIView *lineLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *line2Label;


@end

@implementation STShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setup];
    return self;
}

- (void)setup {
    _showImageView = [[UIImageView alloc] init];
    _showImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _showNameLabel = [[UILabel alloc] init];
    _showNameLabel.font = [UIFont systemFontOfSize:16];
    _showNameLabel.numberOfLines = 2;
    _showNameLabel.textColor = [UIColor blackColor];
    
    _showDateLabel = [[UILabel alloc] init];
    _showDateLabel.font = [UIFont systemFontOfSize:9];
    _showDateLabel.textColor = [UIColor grayColor];
    
    _showLocation = [[UILabel alloc] init];
    _showLocation.textColor = [UIColor grayColor];
    _showLocation.font = [UIFont systemFontOfSize:10];
    
    _price = [[UILabel alloc] init];
    _price.textColor = [UIColor redColor];
    _price.font = [UIFont systemFontOfSize:14];
    
    _lineLabel = [[UIView alloc] init];
    _lineLabel.backgroundColor = [UIColor colorWithHexString:@"#F4153D"];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.font = [UIFont systemFontOfSize:14];
    _descLabel.textColor = [UIColor blackColor];
    
    _line2Label = [[UIView alloc] init];
    _line2Label.backgroundColor = [UIColor colorWithHexString:@"#F4153D"];
    
    [self.contentView addSubview:_showImageView];
    [self.contentView addSubview:_showNameLabel];
    [self.contentView addSubview:_showDateLabel];
    [self.contentView addSubview:_showLocation];
    [self.contentView addSubview:_price];
    [self.contentView addSubview:_lineLabel];
    [self.contentView addSubview:_descLabel];
    [self.contentView addSubview:_line2Label];
    
    [_showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(5);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(120);
    }];
    
    [_showNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_showImageView.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(_showImageView.mas_top).mas_offset(7);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    [_showDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_showNameLabel.mas_left);
        make.right.mas_equalTo(_showNameLabel.mas_right);
        make.top.mas_equalTo(_showNameLabel.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(15);
    }];
    
    [_showLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_showNameLabel.mas_left);
        make.right.mas_equalTo(_showNameLabel.mas_right);
        make.top.mas_equalTo(_showDateLabel.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(15);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_showNameLabel.mas_left);
        make.right.mas_equalTo(_showNameLabel.mas_right);
        make.top.mas_equalTo(_showLocation.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(15);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_showNameLabel.mas_left);
        make.right.mas_equalTo(_showNameLabel.mas_right);
        make.top.mas_equalTo(_price.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(0.3);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_showNameLabel.mas_left);
        make.right.mas_equalTo(_showNameLabel.mas_right);
        make.top.mas_equalTo(_lineLabel.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [_line2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.top.mas_equalTo(_descLabel.mas_bottom).mas_offset(2);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)initWithModel:(STShowModel *)model {
    _model = model;
    if (_model) {
        [_showImageView sd_setImageWithURL:[NSURL URLWithString:_model.posterURL] placeholderImage:[UIImage imageNamed:@"discovery_ProjPlaceHolder"]];
        _showNameLabel.text = _model.showName;
        _showDateLabel.text = _model.showDate;
        _showLocation.text = _model.venueName;
        _price.text = [NSString stringWithFormat:@"%@元起",_model.minPrice];
        _descLabel.text = _model.advertise.length ? _model.advertise : @"去现场为所爱";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
