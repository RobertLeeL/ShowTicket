//
//  STDataBase.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/12.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STDataBase.h"
#import "HttpTool.h"
#import <YTKKeyValueStore.h>

@implementation STDataBase

+ (instancetype)shareInstance {
    static STDataBase *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[STDataBase alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    [self setDataBase];
    return self;
}

- (void)setDataBase {
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"citiesOID.db"];
    NSString *tableName = @"cities_table";
    [store createTableWithName:tableName];
    
    [HttpTool getUrlWithString:@"https://www.tking.cn/showapi/mobile/cities?isSupportSession=1&src=ios&ver=4.1.0" parameters:nil success:^(id responseObject) {
        if (responseObject) {
            NSDictionary *result = responseObject[@"result"];
            NSArray *allcities = result[@"allCities"];
            for (NSDictionary *citiesDict in allcities) {
                NSArray *cities = citiesDict[@"cities"];
                for (NSDictionary *city in cities) {
                    NSString *cityOID = city[@"cityOID"];
                    NSString *cityName = city[@"cityName"];
                    [store putString:cityOID withId:cityName intoTable:tableName];
                }
                
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
