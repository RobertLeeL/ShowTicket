//
//  STDetailNavBarView.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/11.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STDetailNavBarView;

typedef enum : NSUInteger {
    STDetailBackButton,
    STDetailLikeButton,
    STDetailShareButton,
} STDetailButtonType;

@protocol STDetailNavBarViewDelegate <NSObject>

-(void)userPagNavBar:(STDetailNavBarView *)navBar didClickButton:(STDetailButtonType)buttonType;

@end

@interface STDetailNavBarView : UIView

+(STDetailNavBarView *)STDetailNavBar;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (nonatomic, weak) id<STDetailNavBarViewDelegate> delegate;
@property(nonatomic,assign) CGFloat st_alpha;
@end
