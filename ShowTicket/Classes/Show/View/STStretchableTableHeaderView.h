//
//  STStretchableTableHeaderView.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/11.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface STStretchableTableHeaderView : NSObject

@property (nonatomic,retain) UITableView* tableView;
@property (nonatomic,retain) UIView* view;

- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view;
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
- (void)resizeView;

@end
