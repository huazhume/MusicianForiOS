//
//  MAVAudioPlayer.h
//  Moment
//
//  Created by lenservice on 16/4/21.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


@protocol MAVAudioPlayerDelegate <NSObject>

//设置代理

- (void)MAVAudioPlayerBeiginLoadVoice;
- (void)MAVAudioPlayerBeiginPlay;
- (void)MAVAudioPlayerDidFinishPlay;

@end

@interface MAVAudioPlayer : NSObject
@property (nonatomic, strong)AVAudioPlayer *player;
@property (nonatomic, assign)id <MAVAudioPlayerDelegate> delegate;

+(MAVAudioPlayer *)sharedInstance;

//播放音乐
-(void)playSongWithUrl:(NSString *)songUrl;
-(void)playSongWithData:(NSData *)songData;

//停止播放
-(void)stopSound;
@end
