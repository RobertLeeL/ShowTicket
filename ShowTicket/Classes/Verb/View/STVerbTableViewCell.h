//
//  STVerbTableViewCell.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/9.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STShowInformation.h"


@protocol STVerbTableViewCellDelegate <NSObject>

- (void)CustomCollection:(UICollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath model:(STShowInformation *)model;
- (void)didSelectMoreButtonAtIndexPath:(NSIndexPath *)indexPath ;
@end


@interface STVerbTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) id<STVerbTableViewCellDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
