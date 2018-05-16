//
//  NSString+check.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/16.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "NSString+check.h"

@implementation NSString (check)

- (BOOL)checkPhoneNumer {
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self];
    
    if (!isMatch)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)checkEmail {
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [emailTest evaluateWithObject:self];
}

@end
