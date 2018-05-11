//
//  STVerbTableViewCell.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/9.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STVerbTableViewCell.h"
#import <Masonry.h>
#import "STVerbCollectionViewCell.h"

@interface STVerbTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *moreButton;



@end

@implementation STVerbTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = [UIColor blackColor];
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(didSelected) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_typeLabel];
        [self.contentView addSubview:_moreButton];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
        }];
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-5);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake(90, 200);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, self.contentView.frame.size.width, 200) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[STVerbCollectionViewCell class] forCellWithReuseIdentifier:@"cell333"];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [self.contentView addSubview:_collectionView];
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    STVerbCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell333" forIndexPath:indexPath];
    [cell initWithModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomCollection: didSelectRowAtIndexPath:model:)]) {
        [self.delegate CustomCollection:collectionView didSelectRowAtIndexPath:indexPath model:self.dataArray[indexPath.row]];
    }

}

- (void)didSelected {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectMoreButton)]) {
        [self.delegate didSelectMoreButtonAtIndexPath:self.indexPath];
    }
}



@end
