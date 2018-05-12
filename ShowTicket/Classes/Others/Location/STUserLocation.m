//
//  STUserLocation.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/3/20.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STUserLocation.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface STUserLocation()<CLLocationManagerDelegate>

//@property (nonatomic, assign) double lat;
//@property (nonatomic, assign) double lon;
//@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) userLocation userLocationBlock;


@end

@implementation STUserLocation

+ (instancetype)shareInstance {
    static STUserLocation *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[STUserLocation alloc]init];
    });
    return instance;
}

- (instancetype)init {
    if (self ) {
        self = [super init];
        self.manager = [[CLLocationManager alloc]init];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            [self.manager requestWhenInUseAuthorization];
        }
        self.manager.delegate = self;
    }
    return self;
}


- (void)getUserLocation:(userLocation)userLocation {
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
        &&[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        //位置服务是在设置中禁用
        
        _userLocationBlock = [userLocation copy];
        _userLocationBlock(39.9110130000,116.4135540000,@"北京");
        if (self.delegate && [self.delegate respondsToSelector:@selector(getLocationAuthorityDenied)]) {
            [self.delegate getLocationAuthorityDenied];
        }
        return;
    }
    _userLocationBlock = [userLocation copy];
    //    每隔多少米定位一次
    self.manager.distanceFilter = 3000;
    //    开始用户定位
    [self.manager startUpdatingLocation];
}

#pragma mark -
#pragma mark - CLLocatoinManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            NSString *cityName = placemarks.lastObject.addressDictionary[@"City"];
            NSString *str = [cityName substringToIndex:cityName.length -1];
            _userLocationBlock(location.coordinate.latitude,location.coordinate.longitude,str);        }
    }];
    [_manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

@end
