//
//  STShowModel.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/10.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STShowType.h"
#import "STShowStatus.h"

@interface STShowModel : NSObject

@property (nonatomic, copy) NSString *favour;
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, copy) NSString *firstShowTime;
@property (nonatomic, copy) NSString *firstShowTime_weekday;
@property (nonatomic, copy) NSString *hits;
@property (nonatomic, copy) NSString *isPermanent;
@property (nonatomic, copy) NSString *keyWords;
@property (nonatomic, copy) NSString *lastShowTime;
@property (nonatomic, copy) NSString *lastShowTime_weekday;
@property (nonatomic, copy) NSString *latestShowTime;
@property (nonatomic, copy) NSString *latestShowTime_long;
@property (nonatomic, copy) NSString *latestShowTime_weekday;
@property (nonatomic, copy) NSString *limitation;
@property (nonatomic, copy) NSString *minPrice;
@property (nonatomic, copy) NSString *posterURL;
@property (nonatomic, copy) NSString *relativePointDistance;
@property (nonatomic, copy) NSString *shortShowDate;
@property (nonatomic, copy) NSString *showDate;
@property (nonatomic, copy) NSString *showName;
@property (nonatomic, copy) NSString *showOID;
@property (nonatomic, copy) NSString *showdiscount;
@property (nonatomic, copy) NSString *supportCoupon;
@property (nonatomic, copy) NSString *supportSeatPicking;
@property (nonatomic, copy) NSString *supportVisiblePicking;
@property (nonatomic, copy) NSString *supportVr;
@property (nonatomic, copy) NSString *ticketEnterTime;
@property (nonatomic, copy) NSString *venueName;
@property (nonatomic, copy) NSString *venueOID;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *advertise;
@property (nonatomic, strong) STShowType *showType;
@property (nonatomic, strong) STShowStatus *showStatus;


@end
