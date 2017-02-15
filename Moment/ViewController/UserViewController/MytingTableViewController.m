//
//  MytingTableViewController.m
//  Moment
//
//  Created by lenservice on 16/4/27.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "MytingTableViewController.h"
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


@interface MytingTableViewController ()
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


@property (nonatomic ,assign)NSTimeInterval duration;
@property (nonatomic, strong) NSTimer *workTimer;
@property (nonatomic, strong) NSMutableArray *items;

@property(nonatomic ,strong)NSTimer * timer;
@end

static NSInteger  playerIndex = 222222222;//赋较大的值
@implementation MytingTableViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    timeSec = 0;
    self.navigationItem.title = @"我的收录";
    audioPlayer = [MAVAudioPlayer sharedInstance];
    audioPlayer.delegate = self;
    //[self loadData];
    //tableView下移一段距离
    _dataList =[NSMutableArray array];
    [self loadData];
    self.navigationController.navigationBarHidden = NO;
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    musicProgress = [self.tabBarController.view viewWithTag:33333333];
    
    
  //  [self configUI];
    
//    UIButton * playButton = [self.tabBarController.view viewWithTag:1000000];
//    [playButton addTarget:self action:@selector(audioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton * nextButton = [self.tabBarController.view viewWithTag:2000000];
//    [nextButton addTarget:self action:@selector(audioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
    
//    UIButton * shareButton = [self.tabBarController.view viewWithTag:44444444];
//    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)loadData{
    _dataList = [[ModelManager new]readAll];
    
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

//
//-(void)configUI{
//    [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"hotCell"];
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return _dataList.count;
//    
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    HotTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"hotCell"];
//    
//    if(!cell){
//        cell = [[NSBundle mainBundle] loadNibNamed:@"HotTableViewCell" owner:self options:nil][0];
//    }
//    
//    MusicModel* model = _dataList[indexPath.row];
//    NSString * songNameStr = [[NSString alloc]init];
//    if([model.songname containsString:@"("]){
//        int num = 0;
//        for(int i = 0; i<model.songname.length;i++){
//            if([model.songname characterAtIndex:i]== '('){
//                num = i;
//                break;
//            }
//        }
//        songNameStr = [model.songname substringToIndex:num - 1];
//    }
//    else{
//        songNameStr = model.songname;
//    }
//    cell.musicName.text = songNameStr;
//    cell.musicName.font = [UIFont systemFontOfSize:15];
//    cell.musicInfo.text = model.singername;
//    cell.musicInfo.font = [UIFont systemFontOfSize:11];
//    
//    cell.playButton.tag = indexPath.row+1000;
//    
//    [cell.playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
//    cell.musicInfo.textColor = [UIColor colorWithWhite:0.173 alpha:1.000];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.musicIConBtn.backgroundColor = [UIColor blackColor];
//    cell.musicIConBtn.alpha = 0.5;
//    
//    [cell.musicIConBtn setTitle:[NSString stringWithFormat:@"%02ld",indexPath.row+1] forState:UIControlStateNormal];
//    
//    if(indexPath.row >98){
//        cell.musicIConBtn.titleLabel.font = [UIFont boldSystemFontOfSize:26];
//    }
//    else{
//        cell.musicIConBtn.titleLabel.font = [UIFont boldSystemFontOfSize:35];
//    }
//    [cell.musicIConBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cell.musicIcon setImageWithURLString:model.albumpic_big];
//    cell.musicIcon.tag = indexPath.row;
//    
//    if(indexPath.row == playerIndex){
//        
//        if(playerState){
//            
//            [cell.playButton setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
//        }
//        else{
//            
//            [cell.playButton setImage:[UIImage imageNamed:@"player_play.png"] forState:UIControlStateNormal];
//        }
//        
//    }else{
//        
//        [cell.playButton setImage:[UIImage imageNamed:@"player_play.png"] forState:UIControlStateNormal];
//        
//        
//    }
//    
//    return cell;
//}
//
//#pragma mark -
//#pragma mark tableViewCell行高
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 55;
//}
//
//-(void)audioButtonClick:(UIButton * )button{
////    
////    static NSInteger playNowIndex = 2222222222222;
////    UIButton * playButton = (UIButton *)[self.tabBarController.view viewWithTag:1000000 ];
////    if(button.tag ==1000000){
////        //播放
////        if(playerState){
////            //正在播放
////            [playButton setImage:[UIImage imageNamed:@"656759B5-A29A-41B0-B9B1-42625B66D309"] forState:UIControlStateNormal];
////            [audioPlayer stopSound];
////            
////            playNowIndex = playerIndex;
////            playerIndex = 22222222;
////            [self timerStop];
////            
////        }
////        else{
////            //开始播放
////            [playButton setImage:[UIImage imageNamed:@"221A9AB4-7768-423C-AAD7-83601008095F"] forState:UIControlStateNormal];
////            [audioPlayer.player play];
////            playerIndex = playNowIndex;
////            [self startTimer];
////        }
////        
////        playerState = !playerState;
////        
////    }else if (button.tag ==2000000){
////        //下一首
////        //播放
////        
////        [audioPlayer.player stop];
////        
////        MusicModel * model = _dataList[++audioNowIndex];
////        [audioPlayer playSongWithUrl:model.url];
////        
////        [playButton setImage:[UIImage imageNamed:@"221A9AB4-7768-423C-AAD7-83601008095F"] forState:UIControlStateNormal];
////        
////        UIImageView * musicPlayIcon = [self.tabBarController.view viewWithTag:55555555];
////        [musicPlayIcon sd_setImageWithURL:[NSURL URLWithString:model.albumpic_big]];
////        
////        UILabel *musicLab = [self.tabBarController.view viewWithTag:66666666];
////        musicLab.text = model.songname;
////        timeSec = 0;
////        playerState = YES;
////        playerIndex = audioNowIndex;
////    }
////    [self.tableView reloadData];
//}
//
//
//
//-(void)clickPlayButton:(UIButton *)button{
//    
////    
////    [[NSNotificationCenter defaultCenter]postNotificationName:@"AUDIO_START" object:nil];
////    [[NSNotificationCenter defaultCenter]postNotificationName:@"AUDIO_START3" object:nil];
////    
////    MusicModel * model = _dataList[button.tag-1000];
////    //如果没
////    ModelManager *modelM = [ModelManager new];
////    if(![modelM getIsSaveBySongID:model.songid]){
////        [modelM saveMusicModelVo:model];
////    }
////    
////    UIButton * playButton = (UIButton *)[self.tabBarController.view viewWithTag:1000000];
////    if(playerIndex == button.tag - 1000){
////        //点击的是相同的歌曲
////        if(audioPlayer.player.isPlaying){//正在播放的话就暂停
////            
////            [audioPlayer stopSound];
////            playerState = NO;
////            
////            [playButton setImage:[UIImage imageNamed:@"656759B5-A29A-41B0-B9B1-42625B66D309"] forState:UIControlStateNormal];
////            
////            [self timerStop];
////            
////        }
////        else{//已经暂停了就继续播放
////            
////            [audioPlayer.player play];
////            playerState = YES;
////            [playButton setImage:[UIImage imageNamed:@"221A9AB4-7768-423C-AAD7-83601008095F"] forState:UIControlStateNormal];
////            
////            [self startTimer];
////            
////        }
////    }
////    else{//如果点击的是不同的歌曲
////        
////        MusicModel * model1 = _dataList[button.tag-1000];
////        [audioPlayer playSongWithUrl:model1.url];
////        playerState = YES;
////        
////        [playButton setImage:[UIImage imageNamed:@"221A9AB4-7768-423C-AAD7-83601008095F"] forState:UIControlStateNormal];
////        [self timerStop];
////        timeSec =0;
////        // [self startTimer];
////        
////    }
////    
////    playerIndex = button.tag - 1000;
////    [self.tableView reloadData];
////    
////    audioNowIndex = button.tag - 1000;
////    
////    UIImageView * musicPlayIcon = [self.tabBarController.view viewWithTag:55555555];
////    [musicPlayIcon sd_setImageWithURL:[NSURL URLWithString:model.albumpic_big]];
////    
////    UILabel *musicLab = [self.tabBarController.view viewWithTag:66666666];
////    musicLab.text = model.songname;
////    
////    [[NSNotificationCenter defaultCenter]postNotificationName:@"BTN_CLICK" object:self userInfo:@{@"model":model}];
//}
//
//
//
//
//
//#pragma MAVAudioPlayerDelegate
//
//-(void)MAVAudioPlayerBeiginLoadVoice{
//    //缓冲
//    
//    
//}
//-(void)MAVAudioPlayerBeiginPlay{
//    //开始播放
//    UILabel * time1 = [self.tabBarController.view viewWithTag:77777777];
//    
//    NSInteger m = (NSInteger)audioPlayer.player.duration/60;
//    NSInteger s = (NSInteger)audioPlayer.player.duration%60;
//    
//    totolSec =audioPlayer.player.duration;
//    
//    time1.text = [NSString stringWithFormat:@"%02ld:%02ld",m,s];
//    
//    timeLab  = [self.tabBarController.view viewWithTag:123456];
//    // time2.backgroundColor = [UIColor whiteColor];
//    timeLab.text = @"0:00";
//    musicProgress.progress = 0;
//    [self startTimer];
//    
//}
//-(void)MAVAudioPlayerDidFinishPlay{
//    //播放完成
//    playerIndex = 222222;//赋较大的值
//    playerState = NO;
//    UIButton * playButton = (UIButton *)[self.tabBarController.view viewWithTag:1000000 ];
//    [playButton setImage:[UIImage imageNamed:@"656759B5-A29A-41B0-B9B1-42625B66D309"] forState:UIControlStateNormal];
//    [self timerStop];
//    timeSec = 0;
//    musicProgress.progress = 0;
//    timeLab.text = @"0:00";
//    [self.tableView reloadData];
//    
//}
//
//
//
//#pragma mark -
//#pragma mark - 注册通知
//-(void)registNotification{
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(audioOperate:) name:@"AUDIO_START2" object:nil];
//    
//}
//#pragma mark -
//#pragma mark -  销毁通知
//-(void)freeNotification{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AUDIO_START2" object:nil];
//}
//
//-(void)audioOperate:(NSNotification * )notification{
//    if(audioPlayer.player.isPlaying){
//        [audioPlayer.player stop];
//        [self timerStop];
//    }
//    
//    playerIndex = 2222222;
//    playerState = NO;
//    [self timerStop];
//    timeSec = 0;
//    musicProgress.progress = 0;
//    [self.tableView reloadData];
//}
//
//
//-(void)startTimer{
//    if(!_timer){
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
//    }
//    
//}
//-(void)timerRun{
//    timeSec++;
//    
//    NSInteger m = timeSec/60;
//    NSInteger s = timeSec%60;
//    timeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",m,s];
//    NSLog(@"%@",timeLab.text);
//    
//    musicProgress.progress = timeSec/(totolSec *1.00);
//    
//}
//-(void)timerStop{
//    [_timer invalidate];
//    _timer = nil;
//}
//

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
