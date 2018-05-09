//
//  STDiscoveryTableViewCell.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/10.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STDiscoveryTableViewCell.h"
#import <Masonry.h>

@implementation STDiscoveryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setup];
    return self;
}

- (void)setup {
    _image = [[UIImageView alloc] init];
    _image.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_image];
    
    _desLabel = [[UILabel alloc] init];
    _desLabel.font = [UIFont systemFontOfSize:11.0];
    _desLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_desLabel];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
        make.height.mas_equalTo(90);
    }];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_image.mas_left);
        make.right.mas_equalTo(_image.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(5);
        make.height.mas_equalTo(15);
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
