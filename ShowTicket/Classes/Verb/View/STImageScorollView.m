//
//  STImageScorollView.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/4/22.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STImageScorollView.h"

@interface STImageScorollView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation STImageScorollView

- (instancetype)initWithFrame:(CGRect)frame imageList:(NSArray *)imageList {
   self =  [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
