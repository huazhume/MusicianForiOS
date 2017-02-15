//
//  UserInfoDao.m
//  Moment
//
//  Created by lenservice on 16/4/25.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "UserInfoDao.h"

@implementation UserInfoDao

+(void)saveUserInfo:(NSDictionary *)userinfo{
    NSUserDefaults * userNamedeflaut = [NSUserDefaults standardUserDefaults];
    [userNamedeflaut setObject:userinfo  forKey:@"userinfo"];
    [userNamedeflaut synchronize];
}
+(void)saveIsLoginState:(BOOL)isLogin{
    NSUserDefaults * userNamedeflaut = [NSUserDefaults standardUserDefaults];
    [userNamedeflaut setObject:[NSString stringWithFormat:@"%d",isLogin]  forKey:@"isLogin"];
    [userNamedeflaut synchronize];
}
+(NSString *)getIslogin{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"isLogin"];
}
+(NSDictionary *)getUserInfo{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"userinfo"];
}




+(void)saveIntro:(NSString *)intro{
    NSUserDefaults * userNamedeflaut = [NSUserDefaults standardUserDefaults];
    [userNamedeflaut setObject:intro  forKey:@"intro"];
    [userNamedeflaut synchronize];

}
+(NSString *)getintro{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"intro"];
}
@end
