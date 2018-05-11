//
//  STShowDetailVerbTableViewCell.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/11.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STShowDetailVerbTableViewCellDelegate <NSObject>

- (void)didSelctedCellIndex:(NSInteger)index;

@end

@interface STShowDetailVerbTableViewCell : UITableViewCell

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) id<STShowDetailVerbTableViewCellDelegate> delegate;

@end
