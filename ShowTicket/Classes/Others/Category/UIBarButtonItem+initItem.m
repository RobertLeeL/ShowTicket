//
//  UIBarButtonItem+initItem.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/9.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "UIBarButtonItem+initItem.h"
#import "UIButton+extensionClick.h"
#import "UIView+layout.h"

@implementation UIBarButtonItem (initItem)

+ (instancetype)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [tagButton setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [tagButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    tagButton.size = tagButton.currentBackgroundImage.size;
    [tagButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:tagButton];
}

+ (instancetype)itemWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action
{
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [tagButton setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    tagButton.size = tagButton.currentBackgroundImage.size;
    [tagButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:tagButton];
}

+ (instancetype)itemWithTitle:(NSString *)title ImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [tagButton setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [tagButton setTitle:title forState:UIControlStateNormal];
    [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tagButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    tagButton.titleLabel.font = [UIFont systemFontOfSize:14];
    tagButton.size = tagButton.currentImage.size;
    tagButton.width += 40;
    [tagButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:tagButton];
}

- (BOOL)selected
{
    UIButton *button = self.customView;
    
    return button.selected;
}

- (void)setSelected:(BOOL)selected
{
    UIButton *button = self.customView;
    button.selected = selected;
}

@end
