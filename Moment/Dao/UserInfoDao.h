//
//  UserInfoDao.h
//  Moment
//
//  Created by lenservice on 16/4/25.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoDao : NSObject

+(void)saveUserInfo:(NSDictionary *)userinfo;
+(NSDictionary *)getUserInfo;



+(void)saveIsLoginState:(BOOL)isLogin;
+(NSString *)getIslogin;


+(void)saveIntro:(NSString *)intro;
+(NSString *)getintro;
@end
