//
//  STSearchResultView.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/12.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STSearchResultView.h"
#import "common_define.h"
#import "STShowTableViewCell.h"

@interface STSearchResultView () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation STSearchResultView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark -- delegate
#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.sourceData.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_type isEqualToString:@"0"]) {
        static NSString *identifier0 = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier0];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier0];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = UIColorHex(0x646464);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            NSString *imageName =  @"search_history_icon";
            cell.imageView.image = [UIImage imageNamed:imageName];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = UIColorHex(0x282828);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = self.sourceData[indexPath.row];
        return cell;
    } else if ([_type isEqualToString:@"1"]) {
        static NSString *identifier1 = @"searchResultcell";
        STShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[STShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            [cell initWithModel:self.sourceData[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
    }
    }
    static NSString *identifier0 = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier0];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier0];
    }
    cell.textLabel.text = @"哈哈";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_type isEqualToString:@"0"]) {
        
        NSString *keyword = nil;
        
        keyword = self.sourceData[indexPath.row];
        //
        
        self.userInteractionEnabled = NO;
        
        
        if (self.clickResultBlock) {
            self.clickResultBlock(keyword);
            
        }
        
    } else if ([_type isEqualToString:@"1"]) {
        NSLog(@"121");
        if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(didSelectedTableView:indexPath:)]) {
            [self.myDelegate didSelectedTableView:tableView indexPath:indexPath];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)setType:(NSString *)type {
    _type = type;
}
#pragma mark -- groupHeadView
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([self.type isEqualToString:@"0"]) {
        
        NSArray *originData = [[NSUserDefaults standardUserDefaults] objectForKey:kHistroySearchData];
        if (originData.count == 0) return nil;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTagTitleHeight+10)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTagTitleHeight)];
        tipLabel.text = @"   历史搜索";
        tipLabel.backgroundColor = [UIColor whiteColor];
        tipLabel.textColor = UIColorHex(0x646464);
        tipLabel.font = [UIFont boldSystemFontOfSize:15];
        [view addSubview:tipLabel];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(SCREEN_WIDTH-30, 0, 20, 20);
        [deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        deleteBtn.contentMode = UIViewContentModeCenter;
        [view addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *originData = [[NSUserDefaults standardUserDefaults] objectForKey:kHistroySearchData];
    return [self.type isEqualToString:@"0"] ? (originData.count == 0 ? 0.01 : 30.f) : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark -- Action
- (void)deleteAction {
    if (self.clickDeleteBlock) {
        self.clickDeleteBlock();
    }
}
#pragma mark -- LazyLoad
- (NSMutableArray *)sourceData {
    if (!_sourceData) {
        _sourceData = @[].mutableCopy;
    }
    return _sourceData;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
