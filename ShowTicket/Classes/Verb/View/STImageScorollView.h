//
//  STImageScorollView.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/4/22.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>

@protocol STImageScrollViewDelegate <NSObject>
- (void)didSelectedTitleButtonIndex:(NSInteger)index;
- (void)didsSelectedImageIndex:(NSInteger)index;
@end

@interface STImageScorollView : UIView


@property (nonatomic, weak) id<STImageScrollViewDelegate> delegate;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imagesURLStrings;

//- (void)reloadImageScrollView;

@end
