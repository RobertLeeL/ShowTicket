//
//  STBannerInformation.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/9.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STShowType.h"
#import "STBannerType.h"

@interface STBannerInformation : NSObject

@property (nonatomic, copy) NSString *bannerIndex;
@property (nonatomic, copy) NSString *bannerName;
@property (nonatomic, copy) NSString *bannerOID;
@property (nonatomic, copy) NSString *bannerTime;
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic, copy) NSString *blurColour;
@property (nonatomic, copy) NSString *colour;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *endTime_long;
@property (nonatomic, copy) NSString *endTime_weekday;
@property (nonatomic, copy) NSString *posterUrl;
@property (nonatomic, copy) NSString *seq;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *startTime_long;
@property (nonatomic, copy) NSString *startTime_weekday;
@property (nonatomic, copy) NSString *stationOID;
@property (nonatomic, copy) NSString *bannerTime_long;
@property (nonatomic, copy) NSString *bannerTime_weekday;
@property (nonatomic, strong) STShowType *showType;
@property (nonatomic, strong) STBannerType *bannerType;





@end
