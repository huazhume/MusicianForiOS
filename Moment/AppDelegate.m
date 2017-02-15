//
//  AppDelegate.m
//  Moment
//
//  Created by lenservice on 16/3/9.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "MomentingIntroViewController.h"
#import "AVOSCloud.h"

#import "UMSocial.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
//#import <AVFoundation/AVFoundation.h>

#import "MAVAudioPlayer.h"
#import "UserInfoDao.h"

//#import "UMSocialSinaSSOHandler.h"

@interface AppDelegate ()
@property(strong,nonatomic)UIView * lunchView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UMSocialData setAppKey:@"561f6d3fe0f55a753e001969"];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    //qq的AppID
    [UMSocialWechatHandler setWXAppId:@"wxfc820a2f03e2fe54" appSecret:@"8713e6b10d1ca942d3af5a546ae8fabc" url:@"https://itunes.apple.com/cn/app/id1047667835"];
    [UMSocialQQHandler setQQWithAppId:@"1104832799" appKey:@"gT4OrnDMuumrtyfm" url:@"https://itunes.apple.com/cn/app/id1047667835"];
    
    
    [AVOSCloud setApplicationId:@"2e4hl95km1gulauetjvh6orblx9hozmewpnfjbdr403bnz9d"
                     clientKey:@"pj5s0fj0sfrdw54j0n0qox2px5grfm7pgwhpm06byrwoc809"];
  
    
    if([[UserInfoDao getintro]isEqualToString:@"YES"]){
        [self configFormalUI];
    }else{
        [self configIntroUI];
    }
    
    
    

    return YES;
}


-(void)configFormalUI{
    
     self.window.rootViewController = [[RootViewController alloc]init];
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController * vc = [board instantiateInitialViewController];
    // _lunchView.frame = [UIScreen mainScreen].bounds;
    _lunchView = vc.view;
    _lunchView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20);
    [self.window addSubview:_lunchView];
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * filePath = [[NSString alloc]initWithFormat:@"%@/%@",DocumentsPath,@"screen.png"];
    if([fileManager fileExistsAtPath:filePath]){
        imageV.image = [UIImage imageWithContentsOfFile:filePath];
        
    }else{
        imageV.image = [UIImage imageNamed:@"screen"];
        
    }
    [_lunchView addSubview:imageV];
    
    [self.window makeKeyAndVisible];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-20, SCREEN_WIDTH, 40)];
    label.text = @"世界很美，而你正好有空";
    // label.shadowColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [imageV addSubview:label];
    [self.window bringSubviewToFront:_lunchView];
    
    [UIView animateWithDuration:3 animations:^{
        imageV.bounds = CGRectMake(0, 0, 1.1*SCREEN_WIDTH, 1.1*SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [imageV removeFromSuperview];
        [_lunchView removeFromSuperview];
    }];
}


-(void)configIntroUI{
    
    MomentingIntroViewController * introVC = [[MomentingIntroViewController alloc]init];
   // UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:introVC];
    self.window.rootViewController = introVC;
    [self.window makeKeyAndVisible];
    
}






- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents]; // 让后台可以处理多媒体的事件
    NSLog(@"%s",__FUNCTION__);
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil]; //后台播放
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
//    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"我的歌声里" ofType:@"mp3"];
//    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    // 创建播放器
    MAVAudioPlayer *audioPlayer = [MAVAudioPlayer sharedInstance]; //赋值给自己定义的类变量
    
    
    if(audioPlayer.player.isPlaying)
    {
        [audioPlayer.player play]; //播放
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UMSocialSnsService applicationDidBecomeActive];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
