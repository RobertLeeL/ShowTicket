//
//  STUserLocation.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/3/20.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^userLocation)(double lat,double lon, NSString *cityName);

@interface STUserLocation : NSObject

//获取用户信息
@property (nonatomic, assign, readonly) double lat;
@property (nonatomic, assign, readonly) double lon;
@property (nonatomic, copy, readonly) NSString *cityName;

+ (instancetype)shareInstance;

- (void)getUserLocation:(userLocation)userLocation;

@end
