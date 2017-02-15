//
//  RootViewController.m
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import "RootViewController.h"
#import "HotTableViewController.h"
#import "CateTableViewController.h"
#import "FavTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicModel.h"

#import "DataService.h"

#import "MAVAudioPlayer.h"
//按钮控制view上下


typedef enum
{
    kUp,
    kDown
}playButtonState;


@interface RootViewController ()
{
    NSInteger _state;
    
    UILabel * tishiLab;
}
@property(nonatomic ,strong) UILabel * playLabel;
@property(nonatomic ,strong) UIButton * playButton;
@property(nonatomic ,strong) UIImageView * playImage;
@property(nonatomic ,strong) UIView * playView;
@property(nonatomic ,assign) playButtonState * playButtonState;
@property(nonatomic ,strong) UIProgressView * progress;
@property(nonatomic ,strong) UILabel * mesLab;
@property(nonatomic ,copy)NSString * audioFilename;

@property(nonatomic ,strong)UIButton * audioPlayButton;
@property(nonatomic ,strong)UIButton * audioNextButton;
@property(nonatomic ,strong)UIButton * audioShareButton;
@property(nonatomic ,strong)UIImageView * musicPlayingIcon;
@property(nonatomic ,strong)UILabel * musicPlayingTimeLab;
@property(nonatomic ,strong)UILabel * musicPlayingTimeLab2;
@property(nonatomic ,strong)UILabel * musicPlayingName;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadScreenData];
    // Do any additional setup after loading the view.
}
#pragma mark - 
#pragma mark 初始化界面和设置tabbar

-(void)configUI{
    
    //创建tabbar底部按钮
    UIViewController * spaceVC = [[UIViewController alloc]init];
     spaceVC.tabBarItem.enabled = NO;
    
    UINavigationController * hotVC = [[UINavigationController alloc]initWithRootViewController:[[HotTableViewController alloc]init]];
    
    hotVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"热门排行" image:[[UIImage imageNamed:@"tabfirst3"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]selectedImage:nil];

    UINavigationController * cateVC = [[UINavigationController alloc]initWithRootViewController:[[CateTableViewController alloc]init]];
    
    cateVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"分类浏览" image:[[UIImage imageNamed:@"tabthird3"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:nil];
    
    UINavigationController * favVC = [[UINavigationController alloc]initWithRootViewController:[[FavTableViewController alloc]init]];
    
    favVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我喜欢的" image:[[UIImage imageNamed:@"tabsecond"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:nil];
    
    UIViewController * playVC = [[UIViewController alloc]init];
    playVC.tabBarItem.enabled = NO;
   
    
//    UIViewController * playVC2 = [[UIViewController alloc]init];
//    playVC.tabBarItem.enabled = NO;
    //分割线
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.7, 10, 1, 30)];
    view.backgroundColor = [UIColor grayColor];
    [self.tabBar addSubview:view];
    //按钮
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(SCREEN_WIDTH*0.8, 0, 0.2*SCREEN_WIDTH, 38);
    [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.tabBar addSubview:_playButton];
    _playButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    _playButton.adjustsImageWhenHighlighted = NO;
  
    [_playButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    //长按手势
   
    //播放提示
    _playLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.8, 38, 0.2*SCREEN_WIDTH, 10)];
    _playLabel.textColor = [UIColor grayColor];
    _playLabel.text = @"正在播放";
    _playLabel.font = [UIFont systemFontOfSize:10];
    _playLabel.textAlignment = NSTextAlignmentCenter;
    [self.tabBar addSubview:_playLabel];
    //播放视图
    UIView * windowsPlayView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 55, SCREEN_WIDTH, 1)];
    windowsPlayView.alpha = 1;
    windowsPlayView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:windowsPlayView];
    
    _playView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 0)];
    _playView.backgroundColor = [UIColor colorWithRed:0.072 green:0.093 blue:0.102 alpha:1.000];
    _playView.alpha = 0.98;
    [self.view addSubview:_playView];
    windowsPlayView.userInteractionEnabled= YES;
    self.tabBar.userInteractionEnabled =  YES;
    _playView.userInteractionEnabled =  YES;
    _playView.autoresizesSubviews =   YES;
    
    tishiLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 13+4, _playView.frame.size.width, 20)];
    tishiLab.text = @"当前没有播放任何歌曲";
    tishiLab.font = [UIFont systemFontOfSize:12];
    tishiLab.textAlignment = NSTextAlignmentCenter;
    tishiLab.textColor = [UIColor whiteColor];
    [_playView addSubview:tishiLab];
    tishiLab.alpha = 0;
    
    _audioPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_audioPlayButton setImage:[UIImage imageNamed:@"656759B5-A29A-41B0-B9B1-42625B66D309"] forState:UIControlStateNormal];
     _audioPlayButton.frame = CGRectMake(SCREEN_WIDTH*0.6-11+4, 13+4, 18, 20);
    _audioPlayButton.alpha = 0;
    [_playView addSubview:_audioPlayButton];
    
    _audioNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_audioNextButton setImage:[UIImage imageNamed:@"A03D6D11-FB5D-4654-A251-E0B029DA0C1A"] forState:UIControlStateNormal];
    _audioNextButton.frame = CGRectMake(SCREEN_WIDTH*0.7, 13+4, 30, 20);
    _audioNextButton.alpha = 0;
    [_playView addSubview:_audioNextButton];
    
    _audioShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_audioShareButton setImage:[UIImage imageNamed:@"57B9236A-F97B-4722-810A-EADDE4B87F09"] forState:UIControlStateNormal];
    _audioShareButton.frame = CGRectMake(SCREEN_WIDTH*0.8+35-11, 13+4, 27, 20);
    _audioShareButton.alpha = 0;
    [_playView addSubview:_audioShareButton];
    _audioShareButton.tag = 3333333333;
    
    _musicPlayingIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 39, 39)];
    _musicPlayingIcon.backgroundColor = [UIColor whiteColor];
    
    _audioPlayButton.tag = 1000000;
    _audioNextButton.tag = 2000000;
    [_playView addSubview:_musicPlayingIcon];
    _musicPlayingIcon.alpha = 0;
    _musicPlayingName = [[UILabel alloc]initWithFrame:CGRectMake(0.17*SCREEN_WIDTH, 10, 0.38*SCREEN_WIDTH, 15)];
    
    [_playView addSubview:_musicPlayingName];
    _musicPlayingName.alpha = 0;
    _musicPlayingName.font = [UIFont systemFontOfSize:9];
    _musicPlayingName.textColor = [UIColor whiteColor];
    
    _musicPlayingTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(0.17*SCREEN_WIDTH, 30, 0.19*SCREEN_WIDTH, 10)];
    [_playView addSubview:_musicPlayingTimeLab];
    _musicPlayingTimeLab.alpha = 0;
    
    _musicPlayingTimeLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0.36*SCREEN_WIDTH, 30, 0.19*SCREEN_WIDTH, 10)];
    
    _musicPlayingTimeLab.font = [UIFont systemFontOfSize:10];
    _musicPlayingTimeLab2.font = [UIFont systemFontOfSize:10];
    _musicPlayingTimeLab2.textColor = [UIColor whiteColor];
    _musicPlayingTimeLab.textColor = [UIColor whiteColor];
    [_playView addSubview:_musicPlayingTimeLab2];
    _musicPlayingTimeLab2.alpha = 0;

    //progress进度条
    _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, -2, SCREEN_WIDTH, 0)];
    [self.tabBar addSubview:_progress];
    _progress.alpha = 0;
    _progress.progress = 0.00;
    _progress.progressTintColor = [UIColor grayColor];
    _progress.trackTintColor = [UIColor whiteColor];

    //tabBar属性的设置
    self.tabBar.tintColor = [UIColor colorWithWhite:0.232 alpha:1.000];
    self.tabBar.barTintColor = [UIColor blackColor];
    self.viewControllers = @[hotVC,cateVC,favVC,spaceVC,playVC];
    self.tabBar.translucent = NO;
    
    [self registNotification];

    _progress.tag = 33333333;
    _audioShareButton.tag = 44444444;
    _musicPlayingIcon.tag = 55555555;
    _musicPlayingName.tag = 66666666;
    _musicPlayingTimeLab.tag = 77777777;
    _musicPlayingTimeLab2.tag = 123456;
    self.tabBar.alpha = 1;
    
}

-(void)dealloc{
    
    [self freeNotification];
}

#pragma mark -
#pragma marek 处理tap单击点击时间
-(void)clickButton:(UITapGestureRecognizer *)tap{
    if(!_state){
        [UIView animateWithDuration:1 animations:^{
        _playView.frame = CGRectMake(0, SCREEN_HEIGHT - 49 -51, SCREEN_WIDTH, 49);
            if([[MAVAudioPlayer sharedInstance].player isPlaying] || [[MAVAudioPlayer sharedInstance].player prepareToPlay]){
                _audioPlayButton.alpha = 1;
                _audioNextButton.alpha = 1;
                _progress.alpha = 1;
                _audioShareButton.alpha = 1;
                _musicPlayingIcon.alpha = 1;
                _musicPlayingName.alpha = 1;
                _musicPlayingTimeLab.alpha = 1;
                _musicPlayingTimeLab2.alpha = 1;
                tishiLab.alpha = 0;
            }
            else{
            
                tishiLab.alpha = 1;
                _progress.alpha = 0;
                _audioPlayButton.alpha = 0;
                _audioNextButton.alpha = 0;
                _audioShareButton.alpha = 0;
                _musicPlayingIcon.alpha = 0;
                _musicPlayingName.alpha = 0;
                _musicPlayingTimeLab.alpha = 0;
                _musicPlayingTimeLab2.alpha = 0;
            }
            
        }];
    }
    else{
        [UIView animateWithDuration:1 animations:^{
            _playView.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 0);
            _progress.alpha = 0;
            _audioPlayButton.alpha = 0;
            _audioNextButton.alpha = 0;
            _audioShareButton.alpha = 0;
             _musicPlayingIcon.alpha = 0;
            _musicPlayingName.alpha = 0;
            _musicPlayingTimeLab.alpha = 0;
            _musicPlayingTimeLab2.alpha = 0;
            tishiLab.alpha = 0;
        }];
    }
    _state = !_state;
}

#pragma mark -
#pragma mark - 注册通知
-(void)registNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openPlayViewNotification:) name:@"BTN_CLICK" object:nil];

}

#pragma mark -
#pragma mark -  销毁通知
-(void)freeNotification{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"BTN_CLICK" object:nil];
}


#pragma mark -
#pragma mark - 通知打开playView
-(void)openPlayViewNotification:(NSNotification *)notify{
    
    [UIView animateWithDuration:1 animations:^{
        
        _playView.frame = CGRectMake(0, SCREEN_HEIGHT -49-51 , SCREEN_WIDTH, 49);
        _audioPlayButton.alpha = 1;
        _audioNextButton.alpha = 1;
        _progress.alpha = 1;
        _audioShareButton.alpha = 1;
         _musicPlayingIcon.alpha = 1;
        _musicPlayingName.alpha = 1;
        _musicPlayingTimeLab.alpha = 1;
        _musicPlayingTimeLab2.alpha = 1;
        
        
    }];
    _state = 1;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)loadScreenData{
    
    [[DataService new]getLaunchScreenImage:^(id data) {
        NSString * path = data;
        [NSThread detachNewThreadSelector:@selector(getImageByUrl:) toTarget:self withObject:path];
    }];
}

-(void)getImageByUrl:(NSString *)path{
    
    UIImage *image=nil;
    NSURL *url=[NSURL URLWithString:path];
    NSData *data=[NSData dataWithContentsOfURL:url];
    if (data) {
        image=[UIImage imageWithData:data];
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/screen.png"] contents:data attributes:nil];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
