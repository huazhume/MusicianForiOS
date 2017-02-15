//
//  FavViewController.m
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import "FavTableViewController.h"

#import "RegistViewController.h"

#import "LoginViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "LogonViewController.h"

#import "UserInfoDao.h"

@interface FavTableViewController ()
@property(nonatomic ,strong)NSArray * dataList;

@end

@implementation FavTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;

    
    self.navigationItem.title = @"我喜欢的";
    _dataList = [NSMutableArray array];
    [self configUI];
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(void)configUI{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2 - 120, SCREEN_WIDTH, 24)];
    label.text = @"查看喜欢的音乐人及最新动态请登陆";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [self.tableView addSubview:label];
    label.alpha =1;
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((SCREEN_WIDTH-100)/2, label.frame.origin.y + label.frame.size.height + 30, 100, 35);
    
    button.backgroundColor = [UIColor colorWithHue:51/255.0 saturation:51/255.0 brightness:51/255.0 alpha:1];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitle:@"登陆" forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
    
    UIButton * registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registButton.frame = CGRectMake(SCREEN_WIDTH/2 - 100 , SCREEN_HEIGHT - 200, 200, 14);
    [registButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registButton setTitle:@"还没有帐号？ 立即注册" forState:UIControlStateNormal];
    [self.view addSubview:registButton];
    
    button.tag = 1000;
    registButton.tag = 2000;
    
    label.font = [UIFont systemFontOfSize:14];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    registButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [button addTarget:self action:@selector(loginAndRegistButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [registButton addTarget:self action:@selector(loginAndRegistButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)loginAndRegistButtonClicked:(UIButton *)button{
   
    
     self.tabBarController.tabBar.hidden = YES;
    if(button.tag == 1000){
        //登陆
        NSLog(@"登陆");
        LoginViewController * lVC = [LoginViewController new];
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:lVC animated:NO];
    
        
    }else{
        //注册
        NSLog(@"注册");
        
        RegistViewController * lVC = [RegistViewController new];
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromBottom;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:lVC animated:NO];

//        vc.modalTransitionStyle =  UIModalTransitionStyleCoverVertical;
//        vc.
//        [self.navigationController pushViewController:[RegistViewController new] animated:YES];
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillAppear:NO];
    if([[UserInfoDao getIslogin]isEqualToString:@"1"]){
        LogonViewController * lVC = [[LogonViewController alloc]init];
        lVC.userInfo = [UserInfoDao getUserInfo];
        [self.navigationController pushViewController:lVC animated:NO];
    }
}
















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


@end
