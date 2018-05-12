//
//  STSearchHotView.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/12.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickHotTagBlock)(NSString *key);

@interface STSearchHotView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     tagColor:(UIColor *)tagColor
                     tagBlock:(ClickHotTagBlock)clickBlock;

/**
 *  整个View的背景颜色
 */
@property (nonatomic, strong) UIColor *bgColor;
/**
 *  设置子标签View的单一颜色
 */
@property (nonatomic, strong) UIColor *tagColor;

/**
 * 热门数组
 */
@property (nonatomic, strong)NSArray *hotKeyArr;

/**
 * 点击标签
 */
@property (nonatomic, copy)ClickHotTagBlock clickBlock;



@end
