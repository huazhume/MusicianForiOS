//
//  CurrentTimeSerVice.m
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import "CurrentTimeSerVice.h"

@implementation CurrentTimeSerVice
+(NSString *)getCurrentTime{
    NSDate * date = [NSDate date];
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = @"yyyyMMddHHmmss";
    NSString * str = [formater stringFromDate:date];
    NSLog(@"%@",str);
    return str;
}
@end
