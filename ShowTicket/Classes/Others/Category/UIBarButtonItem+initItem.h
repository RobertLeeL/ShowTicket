//
//  UIBarButtonItem+initItem.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/9.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (initItem)

@property (assign, nonatomic) BOOL selected;
+ (instancetype)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;
+ (instancetype)itemWithTitle:(NSString *)title ImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;
+ (instancetype)itemWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;


@end
