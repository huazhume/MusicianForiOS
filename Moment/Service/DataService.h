//
//  DataService.h
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject
-(void)getMusicDataList:(void (^)(NSMutableArray *))dataListBlock byCurrentTime:(NSString *)currentTime andResourceNumber:(NSInteger)resourceNumber andPageIndex:(NSInteger)pageIndex;
-(void)searchMusicDataList:(void (^)(NSMutableArray *))dataListBlock bySerarchString:(NSString *)searchString CurrentTime:(NSString *)currentTime  andPageIndex:(NSInteger)pageIndex;


-(void)getLaunchScreenImage:(void (^)(id))dataBlock;
@end
