//
//  MomentingIntroViewController.m
//  LEN
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import "MomentingIntroViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RootViewController.h"
#import "UserInfoDao.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface MomentingIntroViewController ()<UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIScrollView * _levelScrollView;
    UIButton * _getButton;
    UIButton * userIconButton;
    
    UIButton * selectIconImageButton;
    UILabel * userName;
    UILabel * userSelectName;
    UIButton * userNameSelect;
    UITextField * userNameTextField;
    
    UILabel * descriLab ;
    UIImageView * logoImageView;
    UILabel * welcomeLab;
     UILabel * descriLab1;
    
}
@property (nonatomic ,strong)MPMoviePlayerController * moviePlayer;
@end

@implementation MomentingIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registNotification];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)configUI{
    UIView * view1 = [[UIView alloc]init];
    view1.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width*2, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:view1];
    
    
    _levelScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-20)];
    UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2, SCREEN_HEIGHT)];
    image1.image = [UIImage imageNamed:@"balloons"];
    [_levelScrollView addSubview:image1];
    
    _levelScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width *2, [UIScreen mainScreen].bounds.size.height);
    _levelScrollView.contentOffset = CGPointMake(0, 0);
    _levelScrollView.pagingEnabled = NO;
    _levelScrollView.bounces = NO;
    [view1 addSubview:_levelScrollView];
   
    logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-28, [UIScreen mainScreen].bounds.size.height/2-28-100, 56, 56)];
    logoImageView.image = [UIImage imageNamed:@"ic_logo_black_56dp"];
    [self.view addSubview:logoImageView];
    
 welcomeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-28-100+56+10,[UIScreen mainScreen].bounds.size.width , 40)];
    welcomeLab.text = @"Welcome to Momenting";
    [self.view addSubview:welcomeLab];
    
    descriLab = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100+10, [UIScreen mainScreen].bounds.size.height/2-28-100+56+40,180 , 60)];
    descriLab.numberOfLines = 0;
    descriLab.text = @"Join our network of ideas. Read.Write.Respond.";
    [self.view addSubview:descriLab];
    descriLab.font = [UIFont systemFontOfSize:14];
    descriLab.textColor = [UIColor colorWithWhite:0.270 alpha:1.000];
    welcomeLab.font = [UIFont systemFontOfSize:18];
    welcomeLab.textAlignment = NSTextAlignmentCenter;
    _getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _getButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height/2-28-100+56+40+60+50, 100, 56);
    
    [_getButton setTitle:@"Get started" forState:UIControlStateNormal];
    [self.view addSubview:_getButton];
    [_getButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _getButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_getButton addTarget:self action:@selector(getButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _levelScrollView.userInteractionEnabled = NO;
    _levelScrollView.showsHorizontalScrollIndicator = YES;
    
    descriLab1 = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50-50-20+SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height/2-28-100+56+40+60+50+20, 240, 70)];
    descriLab1.text = @"Please set your information. if you do not want to set up. please press the button below";
    descriLab1.numberOfLines = 0;
    descriLab1.textColor = [UIColor colorWithWhite:0.216 alpha:1.000];
    [self.view addSubview:descriLab1];
    [self createMovie];
        
}


-(void)createMovie{
        NSString * path = [[NSBundle mainBundle] pathForResource:@"moment" ofType:@"m4v"];
        NSURL * url = [NSURL fileURLWithPath:path];
        self.moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:url];
        [self.moviePlayer.view setFrame:CGRectMake(SCREEN_WIDTH +  20, 80, self.view.frame.size.width-40,280)];
        self.moviePlayer.controlStyle = MPMovieControlStyleNone;
        self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        self.moviePlayer.fullscreen = YES;
        self.moviePlayer.backgroundView.backgroundColor = [UIColor clearColor];
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer setShouldAutoplay:NO];
        [self.view addSubview:self.moviePlayer.view];
}

#pragma mark -
#pragma mark 事件处理

-(void)getButtonClicked:(UIButton *)button{
    
    NSLog(@"se");
    self.view.userInteractionEnabled = NO;
    [button removeFromSuperview];
    [descriLab removeFromSuperview];
    [logoImageView removeFromSuperview];
    [welcomeLab removeFromSuperview];
    
    [UIView animateWithDuration:1 animations:^{
        
    }];
    [UIView animateWithDuration:1 animations:^{
        
        _levelScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
         descriLab1.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50-50-20, [UIScreen mainScreen].bounds.size.height/2-28-100+56+40+60+50+20, 240, 70);
        self.moviePlayer.view.frame = CGRectMake(20, 80, self.view.frame.size.width-40,280);
        self.moviePlayer.view.layer.cornerRadius = 8;
        self.moviePlayer.view.layer.masksToBounds = YES;
        self.moviePlayer.view.alpha = 0.8;
        
    } completion:^(BOOL finished) {
        
        [self.moviePlayer setShouldAutoplay:YES];
        
    }];
    
}

-(void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
}
-(void)playBackFinished{
    NSLog(@"播放完");
    [UserInfoDao saveIntro:@"YES"];
    [self presentViewController:[RootViewController new] animated:NO completion:nil];
}











































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
