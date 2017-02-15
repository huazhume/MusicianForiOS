//
//  MusicModel.m
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"albumpic_big"]){
        self.imageUrl = value;
    }
    NSLog(@"%@",key);
}
-(instancetype)initWithdictionary:(NSDictionary *)dictionary{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

@end
