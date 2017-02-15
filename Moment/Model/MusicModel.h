//
//  MusicModel.h
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property (nonatomic, strong) NSNumber *songid;
@property (nonatomic, copy) NSString *downUrl;
@property (nonatomic, strong) NSNumber *singerid;
@property (nonatomic, copy) NSString *albumname;
@property (nonatomic, copy) NSString *singername;
@property (nonatomic, strong) NSNumber *albumid;
@property (nonatomic, copy) NSString *songname;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, copy) NSString * albumpic_big;

@property (nonatomic ,copy)NSString * m4a;

-(instancetype)initWithdictionary:(NSDictionary *)dictionary;
@end
