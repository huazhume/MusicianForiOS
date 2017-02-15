//
//  CateViewController.m
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import "CateTableViewController.h"
#import "MJRefresh.h"
#import "DataService.h"
#import "CurrentTimeSerVice.h"
#import "MusicModel.h"
#import "HotTableViewCell.h"
#import "UIImageView+Remote.h"
#import "UIScrollView+SpiralPullToRefresh.h"
#import "HotTableViewController.h"
#import "CateDetailTableViewController.h"
#import "MAVAudioPlayer.h"
#import "HotTableViewController.h"
#import "UIImageView+WebCache.h"

#import "ModelManager.h"


@interface CateTableViewController ()<UISearchDisplayDelegate,MAVAudioPlayerDelegate>
{
    NSArray * _dataList;
    NSDictionary * _dataDic;
    NSMutableArray * _searchDataList;
    UISearchBar * _searchMusicBar;
    UISearchDisplayController * _searchMusicDisplayContrller;
    NSInteger _pageIndex;
    NSString * _searchStr;
    
  //  NSInteger  _pageIndex;
    MAVAudioPlayer * audioPlayer;
    
    
    BOOL playerState;
    
    NSInteger timeSec;
    
    UILabel * timeLab;
    
    UIProgressView * musicProgress;
    
    NSInteger totolSec;
    
    NSInteger audioNowIndex;

}
@property (nonatomic, strong) NSTimer *workTimer;
@property (nonatomic, strong) NSMutableArray *items;

@property(nonatomic ,strong)NSTimer * timer;

@end

@implementation CateTableViewController

static NSInteger  playerIndex = 222222222;//赋较大的值


- (void)viewDidLoad {
    _pageIndex =1;
    audioPlayer = [MAVAudioPlayer sharedInstance];
    audioPlayer.delegate = self;
    [super viewDidLoad];
    self.navigationItem.title = @"分类浏览";
    musicProgress = [self.tabBarController.view viewWithTag:33333333];

    [self loadData];
    UIButton * playButton = [self.tabBarController.view viewWithTag:1000000];
    [playButton addTarget:self action:@selector(audioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * nextButton = [self.tabBarController.view viewWithTag:2000000];
    [nextButton addTarget:self action:@selector(audioButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self configUI];
    [_searchMusicDisplayContrller.searchResultsTableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"hotCell"];
    [self createSearchBar];
    self.tableView.tableFooterView = [[UIView alloc]init];
    _searchMusicBar.placeholder = @"输入歌名，人名";
    _searchMusicBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}


-(void)refreshNomalHeader{
    
    __block CateTableViewController * blockSelf = self;
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
    [self loadData];
    
}




- (void)onAllworkDoneTimer {
    [self.workTimer invalidate];
    self.workTimer = nil;
    [_searchMusicDisplayContrller.searchResultsTableView.pullToRefreshController didFinishRefresh];
    [_searchMusicDisplayContrller.searchResultsTableView reloadData];
}
- (void)statTodoSomething {
    
    [self.workTimer invalidate];
    self.workTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onAllworkDoneTimer) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark 下载数据
-(void)loadData{
    NSArray * arr1 = @[@{@"name":@"内地巅峰榜",@"number":@5},@{@"name":@"港台巅峰榜",@"number":@6},@{@"name":@"欧美巅峰榜",@"number":@3},@{@"name":@"韩国巅峰榜",@"number":@16},@{@"name":@"日本巅峰榜",@"number":@17}];
    
    NSArray * arr2 = @[@{@"name":@"摇滚",@"number":@19},@{@"name":@"民谣",@"number":@18}];
   
    NSArray * arr3 = @[@{@"name":@"美国Billboard单曲榜",@"number":@108},@{@"name":@"英国uk单曲榜",@"number":@107},@{@"name":@"itunes单曲榜",@"number":@123},@{@"name":@"香港单曲榜",@"number":@113}];
    NSDictionary * dic1 = @{@"title":@"流派",@"data":arr2};
    NSDictionary * dic2 = @{@"title":@"地区",@"data":arr1};
    NSDictionary * dic3 = @{@"title":@"单曲榜",@"data":arr3};
    _dataList = @[dic1,dic2,dic3];
}

#pragma mark -
#pragma mark 创建一个搜索栏
-(void)createSearchBar{
    //创建一个searchBar
    
    _searchMusicBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    //将searchBar加到tableView的头文件中
    self.tableView.tableHeaderView = _searchMusicBar;
    //创建一个搜索栏和搜索结果表格的一个controller
    _searchMusicDisplayContrller = [[UISearchDisplayController alloc]initWithSearchBar:_searchMusicBar contentsController:self];
    
     _searchMusicDisplayContrller.searchResultsTableView.pullToRefreshController.waitingAnimation = SpiralPullToRefreshWaitAnimationCircular;
    _searchMusicBar.tintColor = [UIColor blackColor];
    _searchMusicBar.opaque = NO;
    //遵循三个协议和代理
    _searchMusicDisplayContrller.delegate = self;
    _searchMusicDisplayContrller.searchResultsDelegate = self;
    _searchMusicDisplayContrller.searchResultsDataSource = self;
    [self refreshNomalfooter];
    [self refreshNomalHeader];
}
#pragma mark -
#pragma mark 搜索数据
-(void)refreshSearchDataWithString:(NSString *)searchString FromListIndex:(NSInteger)pageIndex{
    [[[DataService alloc]init] searchMusicDataList:^(NSMutableArray *arr) {
        _searchDataList = arr;
        
        NSLog(@"abcdefef%@",arr);
        
        [_searchMusicDisplayContrller.searchResultsTableView reloadData];
    } bySerarchString:searchString CurrentTime:[CurrentTimeSerVice getCurrentTime] andPageIndex:pageIndex];
}
-(void)refreshSearchNextDataWithString:(NSString *)searchString FromListIndex:(NSInteger)pageIndex{
    _pageIndex++;
    [[[DataService alloc]init] searchMusicDataList:^(NSMutableArray *arr) {
        [_searchDataList addObjectsFromArray:arr];
        [_searchMusicDisplayContrller.searchResultsTableView reloadData];
    } bySerarchString:searchString CurrentTime:[CurrentTimeSerVice getCurrentTime] andPageIndex:pageIndex];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    _searchStr = searchString;
    [self refreshSearchDataWithString:searchString FromListIndex:_pageIndex];
    return YES;
}



#pragma mark -
#pragma mark 初始化界面
-(void)configUI{
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}





#pragma mark - tableView Delegate ：代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == _searchMusicDisplayContrller.searchResultsTableView){
        return 1;
    }
    return _dataList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _searchMusicDisplayContrller.searchResultsTableView){
        return _searchDataList.count;
    }
    NSDictionary * dic = _dataList[section];
    return [dic[@"data"] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _searchMusicDisplayContrller.searchResultsTableView){
        HotTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"hotCell"];
        
        if(!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"HotTableViewCell" owner:self options:nil][0];
        }
        
        MusicModel* model = _searchDataList[indexPath.row];
      //  NSString * songNameStr = [[NSString alloc]init];
//        if([model.songname containsString:@"("]){
//            int num = 0;
//            for(int i = 0; i<model.songname.length;i++){
//                if([model.songname characterAtIndex:i]== '('){
//                    num = i;
//                    break;
//                }
//            }
//            songNameStr = [model.songname substringToIndex:num - 1];
//        }
//        else{
           // songNameStr = model.songname;
     //   }
        
        
        NSLog(@"%@",model.songname);
        cell.musicName.text = model.songname;
        cell.musicName.font = [UIFont systemFontOfSize:15];
        cell.musicInfo.text = model.singername;
        cell.musicInfo.font = [UIFont systemFontOfSize:11];
        
        cell.playButton.tag = indexPath.row+1000;
        
        [cell.playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.musicInfo.textColor = [UIColor colorWithWhite:0.173 alpha:1.000];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.musicIConBtn.backgroundColor = [UIColor blackColor];
        cell.musicIConBtn.alpha = 0.5;
        
        [cell.musicIConBtn setTitle:[NSString stringWithFormat:@"%02ld",indexPath.row+1] forState:UIControlStateNormal];
        
        if(indexPath.row >98){
            cell.musicIConBtn.titleLabel.font = [UIFont boldSystemFontOfSize:26];
        }
        else{
            cell.musicIConBtn.titleLabel.font = [UIFont boldSystemFontOfSize:35];
        }
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
    else{
    
        UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cateCell"];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cateCell"];
        }
        NSDictionary * dic = _dataList[indexPath.section];
        NSArray * arr = dic[@"data"];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.textLabel.text = [arr[indexPath.row] objectForKey:@"name"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
          return cell;
    }
  
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == _searchMusicDisplayContrller.searchResultsTableView){
        
        return nil;
        
    }else{

        return  [_dataList[section] objectForKey:@"title"];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _searchMusicDisplayContrller.searchResultsTableView){
        return 55;
    }
    else{
        return 35;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 22;
}

//添加组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(tableView == _searchMusicDisplayContrller.searchResultsTableView){
        return nil;
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 0, 0)];
    label.text =[NSString stringWithFormat:@"   %@",[_dataList[section] objectForKey:@"title"]];
    label.backgroundColor = [UIColor colorWithWhite:0.860 alpha:1.000];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

//添加上啦加载
-(void)refreshNomalfooter{
    _pageIndex ++;
    __block CateTableViewController* blockSelf = self;
    _searchMusicDisplayContrller.searchResultsTableView.footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [blockSelf refreshSearchNextDataWithString:_searchStr FromListIndex:_pageIndex];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([_searchMusicDisplayContrller.searchResultsTableView.footer isRefreshing]){
                [_searchMusicDisplayContrller.searchResultsTableView.footer endRefreshing];
                NSLog(@"刷新失败");
            }
            
        });
    }];
}


//控制器之间跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _searchMusicDisplayContrller.searchResultsTableView){
        
    }else{
        NSDictionary * dic = _dataList[indexPath.section];
        NSDictionary * dic1 = dic[@"data"][indexPath.row] ;
        NSInteger  num = [dic1[@"number"]integerValue];
        
        CateDetailTableViewController * vc = [CateDetailTableViewController new];
        vc.topicNum = num;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 事件处理

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
        
        MusicModel * model = _searchDataList[++audioNowIndex];
        [audioPlayer playSongWithUrl:model.m4a];
        
        [playButton setImage:[UIImage imageNamed:@"221A9AB4-7768-423C-AAD7-83601008095F"] forState:UIControlStateNormal];
        
        UIImageView * musicPlayIcon = [self.tabBarController.view viewWithTag:55555555];
        [musicPlayIcon sd_setImageWithURL:[NSURL URLWithString:model.albumpic_big]];
        
        UILabel *musicLab = [self.tabBarController.view viewWithTag:66666666];
        musicLab.text = model.songname;
        timeSec = 0;
        playerState = YES;
        playerIndex = audioNowIndex;
    }
    [_searchMusicDisplayContrller.searchResultsTableView reloadData];
}



-(void)clickPlayButton:(UIButton *)button{
    
    [_searchMusicBar endEditing:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AUDIO_START" object:nil];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"AUDIO_START2" object:nil];
    MusicModel * model = _searchDataList[button.tag-1000];
    
    
    ModelManager *modelM = [ModelManager new];
    if(![modelM getIsSaveBySongID:model.songid]){
        [modelM saveMusicModelVo:model];
    }
    
    
    UIButton * playButton = (UIButton *)[self.tabBarController.view viewWithTag:1000000];
    if(playerIndex == button.tag - 1000){
        //点击的是相同的歌曲
        if(playerState){//正在播放的话就暂停
            
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
        
        MusicModel * model1 = _searchDataList[button.tag-1000];
        [audioPlayer playSongWithUrl:model1.m4a];
        playerState = YES;
        
        [playButton setImage:[UIImage imageNamed:@"221A9AB4-7768-423C-AAD7-83601008095F"] forState:UIControlStateNormal];
        [self timerStop];
        timeSec =0;
        //   [self startTimer];
        
    }
    
    playerIndex = button.tag - 1000;
    [_searchMusicDisplayContrller.searchResultsTableView reloadData];
    
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
    [self startTimer];
    
}
-(void)MAVAudioPlayerDidFinishPlay{
   
    //播放完成
    playerIndex = 222222;//赋较大的值
    playerState = NO;
    UIButton * playButton = (UIButton *)[self.tabBarController.view viewWithTag:1000000 ];
    [playButton setImage:[UIImage imageNamed:@"656759B5-A29A-41B0-B9B1-42625B66D309"] forState:UIControlStateNormal];
    [self.tableView reloadData];
  
    [self timerStop];
    timeSec = 0;
    musicProgress.progress = 0;
    timeLab.text = @"0:00";
    
}



#pragma mark -
#pragma mark - 注册通知
-(void)registNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(audioOperate:) name:@"AUDIO_START3" object:nil];
}
#pragma mark -
#pragma mark -  销毁通知
-(void)freeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AUDIO_START3" object:nil];
}

-(void)audioOperate:(NSNotification * )notification{
    if(audioPlayer.player.isPlaying){
        [audioPlayer.player stop];
         [self timerStop];
    }
    playerIndex = 2222222;
    playerState = NO;
   
    timeSec = 0;
    musicProgress.progress = 0;
    [_searchMusicDisplayContrller.searchResultsTableView reloadData];
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



- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
