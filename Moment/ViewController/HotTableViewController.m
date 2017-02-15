//
//  HotTableViewController.m
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import "HotTableViewController.h"
#import "LoadingAnimation.h"
#import "HotTableViewCell.h"
#import "MJRefresh.h"
#import "DataService.h"
#import "CurrentTimeSerVice.h"
#import "HotTableViewCell.h"
#import "MusicModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+Remote.h"
#import "UIScrollView+SpiralPullToRefresh.h"

#import "MAVAudioPlayer.h"
#import "UIImageView+WebCache.h"
#import "ModelManager.h"
#import "UMSocial.h"


@interface HotTableViewController ()<MAVAudioPlayerDelegate, UMSocialUIDelegate>

{
    NSArray * _dataList;
    NSInteger  _pageIndex;
    MAVAudioPlayer * audioPlayer;
    NSInteger  lastPlayerIndex;
    
    BOOL playerState;
    
    NSInteger timeSec;
    
    UILabel * timeLab;
    
    UIProgressView * musicProgress;
    
    NSInteger totolSec;
    
    NSInteger audioNowIndex;
    
}
//@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic ,assign)NSTimeInterval duration;
@property (nonatomic, strong) NSTimer *workTimer;
@property (nonatomic, strong) NSMutableArray *items;

@property(nonatomic ,strong)NSTimer * timer;
@end

@implementation HotTableViewController

static NSInteger  playerIndex = 222222222;//赋较大的值

-(void)viewWillAppear:(BOOL)animated{
    //self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    timeSec = 0;
    self.navigationItem.title = @"音乐人";
    audioPlayer = [MAVAudioPlayer sharedInstance];
    audioPlayer.delegate = self;
    [self refreshData];
    //tableView下移一段距离
    _dataList =[NSMutableArray array];
    self.navigationController.navigationBarHidden = NO;
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.tableFooterView = [[UIView alloc]init];
   // self.tableView.contentInset = UIEdgeInsetsMake(0.05*SCREEN_HEIGHT, 0, 0, 0);
    
    
    //加载动画
    LoadingAnimation * view = [[LoadingAnimation alloc]initWithFrame:self.view.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view timerStop];
        [view removeFromSuperview];
     
    });
    _pageIndex = 1;
    self.tableView.pullToRefreshController.waitingAnimation = SpiralPullToRefreshWaitAnimationCircular;
    
    
    
    
    
     musicProgress = [self.tabBarController.view viewWithTag:33333333];
    
    
     [self configUI];
    
    UIButton * playButton = [self.tabBarController.view viewWithTag:1000000];
    [playButton addTarget:self action:@selector(audioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * nextButton = [self.tabBarController.view viewWithTag:2000000];
    [nextButton addTarget:self action:@selector(audioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * shareButton = [self.tabBarController.view viewWithTag:44444444];
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}



#pragma mark -
#pragma mark 初始化界面
-(void)configUI{

    [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"hotCell"];
    [self refreshNomalFooter];
    [self registNotification];
    [self refreshNomalHeader];
}


-(void)refreshNomalHeader{
    __block HotTableViewController * blockSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^ {
        int64_t delayInSeconds = 2.0;
        [blockSelf refreshTriggered];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [blockSelf onAllworkDoneTimer];
        });
    }];
}


-(void)refreshTriggered{
    [self refreshData];
    
}




- (void)onAllworkDoneTimer {
    [self.workTimer invalidate];
    self.workTimer = nil;
    [self.tableView.pullToRefreshController didFinishRefresh];
    [self.tableView reloadData];
}



- (void)statTodoSomething {
    
    [self.workTimer invalidate];
    self.workTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onAllworkDoneTimer) userInfo:nil repeats:NO];
}


#pragma mark -
#pragma mark 下载刷新数据
-(void)refreshData{
       // [view startTimer];
    __block HotTableViewController * blockSelf = self;
    
    [[[DataService alloc]init] getMusicDataList:^(NSMutableArray *arr) {
        
        _dataList = arr;
                NSLog(@"sdfasfdasdf%@",arr);
        [blockSelf.tableView reloadData];
        if([blockSelf.tableView.header isRefreshing]){
           [blockSelf.tableView.header endRefreshing];
        }
        //参数ResourceNumber 表示链接中请求专辑序列代码，4表示热门专辑
    } byCurrentTime:[CurrentTimeSerVice getCurrentTime] andResourceNumber:26 andPageIndex:_pageIndex];
    
    
}
#pragma mark -
#pragma mark 刷新下一页
-(void)refreshNextData{
    
    _pageIndex++;
    __block HotTableViewController * blockSelf = self;
    [[[DataService alloc]init] getMusicDataList:^(NSMutableArray *arr) {
       
        NSMutableArray * dataListArr = [[NSMutableArray alloc]init];
        [dataListArr addObjectsFromArray:_dataList];
        [dataListArr addObjectsFromArray:arr];
        _dataList = dataListArr;
        [blockSelf.tableView reloadData];

        if([blockSelf.tableView.footer isRefreshing]){
            [blockSelf.tableView.footer endRefreshing];
        }
        //参数ResourceNumber 表示链接中请求专辑序列代码，4表示热门专辑
    } byCurrentTime:[CurrentTimeSerVice getCurrentTime] andResourceNumber:26 andPageIndex:_pageIndex];
    
}

#pragma mark - 
#pragma mark 设置下拉刷新
//-(void)refreshNomalHeader{
//    __block HotTableViewController * blockSelf = self;
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [blockSelf refreshData];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if([blockSelf.tableView.header isRefreshing]){
//                [blockSelf.tableView.header endRefreshing];
//                NSLog(@"刷新失败");
//            }
//
//        });
//    }];
//}

#pragma mark -
#pragma mark 设置上拉加载
-(void)refreshNomalFooter{
    
    __block HotTableViewController * blockSelf = self;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [blockSelf refreshNextData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([blockSelf.tableView.footer isRefreshing]){
                [blockSelf.tableView.footer endRefreshing];
                NSLog(@"刷新失败");
            }
            
        });
    }];
    
}


#pragma mark -
#pragma mark tableViewCell代理设置

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataList.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    HotTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"hotCell"];

    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"HotTableViewCell" owner:self options:nil][0];
    }
    
    MusicModel* model = _dataList[indexPath.row];
    NSString * songNameStr = [[NSString alloc]init];
    if([model.songname containsString:@"("]){
        int num = 0;
        for(int i = 0; i<model.songname.length;i++){
            if([model.songname characterAtIndex:i]== '('){
                num = i;
                break;
            }
        }
        songNameStr = [model.songname substringToIndex:num - 1];
    }
    else{
        songNameStr = model.songname;
    }
    cell.musicName.text = songNameStr;
    cell.musicInfo.text = model.singername;
    cell.playButton.tag = indexPath.row+1000;
    
    [cell.playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.musicIConBtn.backgroundColor = [UIColor blackColor];
    cell.musicIConBtn.alpha = 0.5;
    cell.musicIConBtn.titleLabel.font = [UIFont systemFontOfSize:29];
    
    [cell.musicIConBtn setTitle:[NSString stringWithFormat:@"%02ld",indexPath.row+1] forState:UIControlStateNormal];
    
//    if(indexPath.row >98){
//        cell.musicIConBtn.titleLabel.font = [UIFont boldSystemFontOfSize:26];
//    }
//    else{
//        cell.musicIConBtn.titleLabel.font = [UIFont boldSystemFontOfSize:35];
    cell.musicIConBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    }
    [cell.musicIConBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.musicIcon setImageWithURLString:model.albumpic_big];
    cell.musicIcon.tag = indexPath.row;
   
    if(indexPath.row == playerIndex){
        
        if(playerState){
            
            [cell.playButton setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        }
        else{
            
          [cell.playButton setImage:[UIImage imageNamed:@"player_play.png"] forState:UIControlStateNormal];
        }
        
    }else{
        
        [cell.playButton setImage:[UIImage imageNamed:@"player_play.png"] forState:UIControlStateNormal];


    }
    
    return cell;
}

#pragma mark - 
#pragma mark tableViewCell行高

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (SCREEN_HEIGHT-60)/10;
}

-(void)audioButtonClick:(UIButton * )button{
    
    static NSInteger playNowIndex = 2222222222222;
    UIButton * playButton = (UIButton *)[self.tabBarController.view viewWithTag:1000000 ];
    if(button.tag ==1000000){
        //播放
        if(playerState){
            //正在播放
            [playButton setImage:[UIImage imageNamed:@"656759B5-A29A-41B0-B9B1-42625B66D309"] forState:UIControlStateNormal];
            [audioPlayer stopSound];
            
            playNowIndex = playerIndex;
            playerIndex = 22222222;
            [self timerStop];
            
        }
        else{
            //开始播放
            [playButton setImage:[UIImage imageNamed:@"221A9AB4-7768-423C-AAD7-83601008095F"] forState:UIControlStateNormal];
            [audioPlayer.player play];
            playerIndex = playNowIndex;
             [self startTimer];
        }
        
        playerState = !playerState;
        
    }else if (button.tag ==2000000){
        //下一首
        //播放
        
        [audioPlayer.player stop];

        MusicModel * model = _dataList[++audioNowIndex];
        [audioPlayer playSongWithUrl:model.url];
        
        [playButton setImage:[UIImage imageNamed:@"221A9AB4-7768-423C-AAD7-83601008095F"] forState:UIControlStateNormal];
       
        UIImageView * musicPlayIcon = [self.tabBarController.view viewWithTag:55555555];
        [musicPlayIcon sd_setImageWithURL:[NSURL URLWithString:model.albumpic_big]];
        
        UILabel *musicLab = [self.tabBarController.view viewWithTag:66666666];
        musicLab.text = model.songname;
        timeSec = 0;
        playerState = YES;
        playerIndex = audioNowIndex;
    }
    [self.tableView reloadData];
}



-(void)clickPlayButton:(UIButton *)button{

    
     [[NSNotificationCenter defaultCenter]postNotificationName:@"AUDIO_START" object:nil];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"AUDIO_START3" object:nil];

    MusicModel * model = _dataList[button.tag-1000];
    //如果没
    
  //  [NSThread detachNewThreadSelector:@selector(saveMusicModelVo:) toTarget:self withObject:model];
    [self saveModelVO:model];
    //延迟一秒
   // [NSThread sleepForTimeInterval:1.0f];
    
   // NSThread
    UIButton * playButton = (UIButton *)[self.tabBarController.view viewWithTag:1000000];
    if(playerIndex == button.tag - 1000){
        //点击的是相同的歌曲
        if(audioPlayer.player.isPlaying){//正在播放的话就暂停
           
            [audioPlayer stopSound];
            playerState = NO;
            
            [playButton setImage:[UIImage imageNamed:@"656759B5-A29A-41B0-B9B1-42625B66D309"] forState:UIControlStateNormal];
            
            [self timerStop];
            
        }
        else{//已经暂停了就继续播放
    
            [audioPlayer.player play];
            playerState = YES;
            [playButton setImage:[UIImage imageNamed:@"221A9AB4-7768-423C-AAD7-83601008095F"] forState:UIControlStateNormal];
            
            [self startTimer];

        }
    }
    else{//如果点击的是不同的歌曲
        
        MusicModel * model1 = _dataList[button.tag-1000];
        [audioPlayer playSongWithUrl:model1.url];
        playerState = YES;
        
        [playButton setImage:[UIImage imageNamed:@"221A9AB4-7768-423C-AAD7-83601008095F"] forState:UIControlStateNormal];
        [self timerStop];
         timeSec =0;
     // [self startTimer];
        
    }
    
    playerIndex = button.tag - 1000;
    [self.tableView reloadData];
    
    audioNowIndex = button.tag - 1000;
    
    UIImageView * musicPlayIcon = [self.tabBarController.view viewWithTag:55555555];
    [musicPlayIcon sd_setImageWithURL:[NSURL URLWithString:model.albumpic_big]];
     
    UILabel *musicLab = [self.tabBarController.view viewWithTag:66666666];
    musicLab.text = model.songname;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"BTN_CLICK" object:self userInfo:@{@"model":model}];
}





#pragma MAVAudioPlayerDelegate

-(void)MAVAudioPlayerBeiginLoadVoice{
    //缓冲

    
}
-(void)MAVAudioPlayerBeiginPlay{
    //开始播放
    UILabel * time1 = [self.tabBarController.view viewWithTag:77777777];
    
    NSInteger m = (NSInteger)audioPlayer.player.duration/60;
    NSInteger s = (NSInteger)audioPlayer.player.duration%60;
    
    totolSec =audioPlayer.player.duration;
    
    time1.text = [NSString stringWithFormat:@"%02ld:%02ld",m,s];
    
    timeLab  = [self.tabBarController.view viewWithTag:123456];
   // time2.backgroundColor = [UIColor whiteColor];
    timeLab.text = @"0:00";
    musicProgress.progress = 0;
    [self startTimer];
    
}
-(void)MAVAudioPlayerDidFinishPlay{
    //播放完成
    playerIndex = 222222;//赋较大的值
    playerState = NO;
    UIButton * playButton = (UIButton *)[self.tabBarController.view viewWithTag:1000000 ];
    [playButton setImage:[UIImage imageNamed:@"656759B5-A29A-41B0-B9B1-42625B66D309"] forState:UIControlStateNormal];
    [self timerStop];
    timeSec = 0;
    musicProgress.progress = 0;
    timeLab.text = @"0:00";
    [self.tableView reloadData];

}



#pragma mark -
#pragma mark - 注册通知
-(void)registNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(audioOperate:) name:@"AUDIO_START2" object:nil];
    
}
#pragma mark -
#pragma mark -  销毁通知
-(void)freeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AUDIO_START2" object:nil];
}

-(void)audioOperate:(NSNotification * )notification{
    if(audioPlayer.player.isPlaying){
        [audioPlayer.player stop];
        [self timerStop];
    }

    playerIndex = 2222222;
    playerState = NO;
    [self timerStop];
    timeSec = 0;
    musicProgress.progress = 0;
    [self.tableView reloadData];
}


-(void)startTimer{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    }

}
-(void)timerRun{
    timeSec++;
    
    NSInteger m = timeSec/60;
    NSInteger s = timeSec%60;
    timeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",m,s];
    NSLog(@"%@",timeLab.text);
    
    musicProgress.progress = timeSec/(totolSec *1.00);

}
-(void)timerStop{
    [_timer invalidate];
    _timer = nil;
}










-(void)shareButtonClicked:(UIButton *)button{
    NSLog(@"shareButtonClicked");
    
    MusicModel * model = _dataList[audioNowIndex];
     UIImageView * musicPlayIcon = [self.tabBarController.view viewWithTag:55555555];
    
    [UMSocialData defaultData].extConfig.qqData.title =model.songname;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = model.songname;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = model.songname;
    [UMSocialData defaultData].extConfig.qzoneData.title = model.songname;
//    [UMSocialData defaultData].extConfig.qqData.url = model.url;
//    [UMSocialData defaultData].extConfig.qzoneData.url = model.url;
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = model.url;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = model.url;
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeMusic url:model.url];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"561f6d3fe0f55a753e001969"
                                      shareText:model.singername
                                     shareImage:musicPlayIcon.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline,UMShareToSina,UMShareToEmail,nil]
                                       delegate:self];
    
    
}





-(void)saveModelVO:(MusicModel *)model{
    ModelManager *modelM = [ModelManager new];
    if(![modelM getIsSaveBySongID:model.songid]){
        [modelM saveMusicModelVo:model];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
