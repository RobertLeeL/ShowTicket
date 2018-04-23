//
//  SelectCityButton.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/4/22.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "SelectCityButton.h"
#import "UIView+layout.h"
#import "UILabel+Width.h"

@implementation SelectCityButton


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = 0;
    self.titleLabel.height = 15;
    self.titleLabel.width = [self.titleLabel getTextWidth];
    
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 5;
    self.imageView.width = self.currentImage.size.width;
    self.imageView.height = self.currentImage.size.height;
    self.imageView.centerY = self.titleLabel.centerY;
    self.width = [self.titleLabel getTextWidth] + self.imageView.width + 5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
