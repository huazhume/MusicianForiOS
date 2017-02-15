//
//  MAVAudioPlayer.m
//  Moment
//
//  Created by lenservice on 16/4/21.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "MAVAudioPlayer.h"
#import "AppDelegate.h"


@interface MAVAudioPlayer ()<AVAudioPlayerDelegate>

@end

@implementation MAVAudioPlayer

+(MAVAudioPlayer *)sharedInstance{
    
    static MAVAudioPlayer * _shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc]init];
    });
    return _shareInstance;
    
}

-(void)playSongWithUrl:(NSString *)songUrl{
    
    dispatch_async(dispatch_queue_create("playSoundFromUrl", NULL), ^{
        [self.delegate MAVAudioPlayerBeiginLoadVoice];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:songUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playSoundWithData:data];
        });
    });
    
}
-(void)playSongWithData:(NSData *)songData{
    [self setupPlaySound];
    [self playSoundWithData:songData];
}


-(void)playSoundWithData:(NSData *)soundData{
    
    //如果播放对象不存在
    if(_player){
        [_player stop];
        _player.delegate = nil;
        _player = nil;
    }
    NSError * playError;
    _player = [[AVAudioPlayer alloc]initWithData:soundData error:&playError];
    _player.volume = 1.0f;
    if(_player == nil){
        NSLog(@"Error creating player : %@",[playError userInfo]);
    }
    _player.delegate = self;
    [_player play];
    [self.delegate MAVAudioPlayerBeiginPlay];
}

-(void)setupPlaySound{
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self.delegate MAVAudioPlayerDidFinishPlay];

}
-(void)stopSound{
    
    if(_player &&_player.isPlaying){
        [_player stop];
    }

}
-(void)applicationWillResignActive:(UIApplication *)application{
    
    [self.delegate MAVAudioPlayerDidFinishPlay];

}









@end
