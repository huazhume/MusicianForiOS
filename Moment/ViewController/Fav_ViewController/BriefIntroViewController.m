//
//  BriefIntroViewController.m
//  Moment
//
//  Created by lenservice on 16/4/25.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "BriefIntroViewController.h"
#import "UserInfoDao.h"

@interface BriefIntroViewController ()
{
    UITextView * textV;
}
@end

@implementation BriefIntroViewController


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"简介";
}
- (void)viewDidLoad {
    [super viewDidLoad];
   // self.view.backgroundColor = [UIColor colorWithHue:240/255.0 saturation:240/255.0 brightness:240/255.0 alpha:1];
    
   textV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [self.view addSubview:textV];
    textV.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
 
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(SCREEN_WIDTH/2 - 88, textV.frame.origin.y + textV.frame.size.height+30,176, 40);
    sureButton.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(176/2- 13, 10, 26, 18)];
    image2.image = [UIImage imageNamed:@"dgts__ic_success"];
    [sureButton addSubview:image2];
    sureButton.layer.cornerRadius = 2;
    sureButton.layer.masksToBounds = YES;
    
    [sureButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    [textV becomeFirstResponder];

    // Do any additional setup after loading the view.
}

-(void)sureButtonClicked:(UIButton *)button{
    [textV endEditing:YES];
    NSDictionary * dic = [UserInfoDao getUserInfo];
 //   [dic setValue:textV.text forKey:@"brief"];
    
    
    NSDictionary *dic2 = @{@"icon":dic[@"icon"],@"username":dic[@"username"],@"brief":textV.text};
    [UserInfoDao saveUserInfo:dic2];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
