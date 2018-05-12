//
//  STSearchResultView.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/12.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STSearchResultViewDelegate <NSObject>
- (void)didSelectedTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

@interface STSearchResultView : UITableView

// 数据源
@property (nonatomic, strong)NSMutableArray *sourceData;

// 0:历史 1:结果
@property (nonatomic, copy)NSString *type;

// 点击cell
@property (nonatomic, copy) void (^clickResultBlock)(NSString *key);

// 清除记录
@property (nonatomic, copy) void (^clickDeleteBlock)(void);

@property (nonatomic, weak) id<STSearchResultViewDelegate> myDelegate;

@end
