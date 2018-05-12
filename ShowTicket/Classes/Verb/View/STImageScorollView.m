//
//  STImageScorollView.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/4/22.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STImageScorollView.h"
#import <SDCycleScrollView.h>
#import "STTitleButton.h"
#import "UIView+layout.h"
#import "STBannerInformation.h"

#define ScreenBounds [[UIScreen mainScreen] bounds]
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface STImageScorollView ()<SDCycleScrollViewDelegate>




@end

@implementation STImageScorollView

- (instancetype)initWithFrame:(CGRect)frame {
   self =  [super initWithFrame:frame];
    if (self) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height / 2) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _scrollView.currentPageDotColor = [UIColor whiteColor];
        [self addSubview:_scrollView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _scrollView.imageURLStringsGroup = self.imagesURLStrings;
        });
        
        [self setup];
    }
    return self;
}

//- (void)reloadImageScrollView {
//    NSMutableArray *posterURLArray = [[NSMutableArray alloc] init];
//    for (STBannerInformation *dict in self.dataArray) {
//        NSString *string = dict.posterUrl;
//        [posterURLArray addObject:string];
//    }
//    _scrollView.imageURLStringsGroup = posterURLArray;
//}

- (void)setup {
    NSArray *array = @[@"演唱会",@"话剧歌剧",@"音乐会",@"体育赛事",@"舞蹈芭蕾",@"儿童亲子",@"展览休闲",@"曲艺杂谈"];
    CGFloat topSpace = 7;
    CGFloat y = _scrollView.y + _scrollView.height + topSpace;
    CGFloat leftSpace = 20;
    CGFloat space = (ScreenWidth - 40 - 50* 4) / 3;
    for (int i = 0; i < array.count; i++) {
        STTitleButton *button = [STTitleButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(leftSpace + (space + 50)*(i % 4)  , y + (2 * topSpace + 45) * (i / 4), 50, 50);
        button.tag = i + 100;
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icons_category_%d",i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)clickButton:(id)sender {
    UIButton *button = sender;
    NSInteger index = button.tag;
//    NSLog(@"%ld",index);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedTitleButtonIndex:)]) {
        [self.delegate didSelectedTitleButtonIndex:index];
    }
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didsSelectedImageIndex:)]) {
        [self.delegate didsSelectedImageIndex:index];
    }
}

@end
