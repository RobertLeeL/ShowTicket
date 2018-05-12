//
//  STSearchNavBarView.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/12.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBarShouldBeginEditingBlock)(UISearchBar *searchBar);

typedef void(^SearchBarSearchButtonClickedBlock)(UISearchBar *searchBar);

@interface STSearchNavBarView : UIView

/**
 * 初始化
 * 开始输入（弹出输入框，显示历史记录 和 热门搜索）
 * 点击搜索 (回调到控制器进行操作)
 */
- (instancetype)initWithFrame:(CGRect)frame
               beginEditBlock:(SearchBarShouldBeginEditingBlock)editBlock
             clickSearchBlock:(SearchBarSearchButtonClickedBlock)searchBlock;

@property (nonatomic, copy)SearchBarShouldBeginEditingBlock beginEditBlock;

@property (nonatomic, copy)SearchBarSearchButtonClickedBlock searchBlock;


//点击取消按钮
@property (nonatomic, copy)dispatch_block_t clickCancelBlock;

//联想搜索开启
@property (nonatomic, copy)void(^tfdDidChangedBlock)(NSString *key);
//开启联想搜索
@property (nonatomic, assign)BOOL openAssociativeSearch;

//输入框
@property (nonatomic, strong) UISearchBar *searchBar;



@end
