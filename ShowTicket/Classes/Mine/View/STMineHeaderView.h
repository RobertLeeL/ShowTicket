//
//  STMineHeaderView.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/9.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STMineHeaderViewDelegate <NSObject>
- (void)clickButtonWithTag:(NSInteger)tag;

@end

@interface STMineHeaderView : UIView
@property (weak, nonatomic) UIImageView *bgView;
@property (weak, nonatomic) UIButton *button;
@property (weak , nonatomic) UIImageView *headImageView;
@property (nonatomic, weak) id<STMineHeaderViewDelegate> delegate;
@end
