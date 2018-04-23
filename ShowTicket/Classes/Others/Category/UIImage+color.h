//
//  UIImage+color.h
//  ShowTicket
//
//  Created by 李龙跃 on 2018/4/22.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (color)

- (UIImage *)coreImageBlurNumber:(CGFloat)blur;
- (UIImage *)boxblurWithBlurNumber:(CGFloat)blur;
/**
 *  用颜色生成指定大小的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
