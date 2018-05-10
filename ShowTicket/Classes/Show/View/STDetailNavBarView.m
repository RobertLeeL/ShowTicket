    //
//  STDetailNavBarView.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/11.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STDetailNavBarView.h"

@implementation STDetailNavBarView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backButton.tag = STDetailBackButton;
}
- (IBAction)buttonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userPagNavBar:didClickButton:)]) {
        [self.delegate userPagNavBar:self didClickButton:sender.tag];
    }
}

+ (STDetailNavBarView *)STDetailNavBar {
    return [[[NSBundle mainBundle] loadNibNamed:@"STDetailNavBarView" owner:nil options:nil] lastObject];
}

- (void)setSt_alpha:(CGFloat)st_alpha {
    _st_alpha = st_alpha;
    self.backImageView.alpha = st_alpha;
    self.titleLabel.hidden = !(st_alpha >= 0.99);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
