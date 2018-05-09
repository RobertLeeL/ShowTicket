//
//  STTitleButton.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/8.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STTitleButton.h"
#import "UIView+layout.h"
#import "UILabel+Width.h"

@implementation STTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageRect = self.imageView.frame;
    imageRect.size = CGSizeMake(40,30);
    imageRect.origin.x = 5;
    imageRect.origin.y = 5;
    
    self.imageView.frame = imageRect;
    
    CGRect labelRect = self.titleLabel.frame;
    labelRect.size = CGSizeMake(50, 15);
    labelRect.origin.x = 0;
    labelRect.origin.y = 35;
    self.titleLabel.frame = labelRect;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
