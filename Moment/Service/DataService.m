//
//  DataService.m
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import "DataService.h"
#import "AFHTTPRequestOperationManager.h"
#import "MusicModel.h"
@implementation DataService

#pragma mark
#pragma mark - 通过当前的时间和专辑编号来获取数据

///
-(void)getMusicDataList:(void (^)(NSMutableArray *))dataListBlock byCurrentTime:(NSString *)currentTime andResourceNumber:(NSInteger)resourceNumber andPageIndex:(NSInteger)pageIndex{
    
    NSString * path = [[NSString stringWithFormat:@"http://route.showapi.com/213-4?topid=%ld&page=%ld&showapi_appid=16626&showapi_timestamp=%@&showapi_sign=e19fa39608784506b3ba0bde1066d83a",resourceNumber,pageIndex, currentTime]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //三方库AFHTTP
    NSLog(@"%@",path);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
     [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject){
            NSDictionary * dic = (NSDictionary *)responseObject;
            NSDictionary * dic1  = dic[@"showapi_res_body"];
            NSDictionary * dic2 = dic1[@"pagebean"];
            NSArray * arr = dic2[@"songlist"];
            NSMutableArray * dataList = [NSMutableArray array];
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MusicModel * model = [[MusicModel alloc]initWithdictionary:obj];
                [dataList addObject:model];
            }];
            dataListBlock(dataList);
            }
        NSLog(@"%@",responseObject) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}
-(void)searchMusicDataList:(void (^)(NSMutableArray *))dataListBlock bySerarchString:(NSString *)searchString CurrentTime:(NSString *)currentTime andPageIndex:(NSInteger)pageIndex{
    
    NSString * path = [[NSString stringWithFormat:@"http://route.showapi.com/213-1?keyword=%@&page=%ld&showapi_appid=9475&showapi_timestamp=%@&showapi_sign=1bfe6dcb6d6c4d28bfa73debdbc3b457",searchString,pageIndex, currentTime]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //三方库AFHTTP
    NSLog(@"%@",path);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject){
            NSDictionary * dic = (NSDictionary *)responseObject;
            NSDictionary * dic1  = dic[@"showapi_res_body"];
            NSDictionary * dic2 = dic1[@"pagebean"];
            NSArray * arr = dic2[@"contentlist"];
            NSMutableArray * dataList = [NSMutableArray array];
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MusicModel * model = [[MusicModel alloc]initWithdictionary:obj];
                [dataList addObject:model];
            }];
            NSLog(@"asfdsdfsadsdfadfasfasdfas%@",dataList);
            dataListBlock(dataList);
            
        }
        NSLog(@"%@",responseObject) ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

    
}



-(void)getLaunchScreenImage:(void (^)(id))dataBlock{
    NSString * LaunchScreen_Path = @"http://api2.pianke.me/pub/screen";
    [[AFHTTPRequestOperationManager manager] POST:LaunchScreen_Path parameters:@{@"client":@"2"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject){
            NSDictionary * dic = responseObject;
            NSDictionary * dic2 = dic[@"data"];
            NSString * str = dic2[@"picurl"];
            dataBlock(str);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
}

@end




