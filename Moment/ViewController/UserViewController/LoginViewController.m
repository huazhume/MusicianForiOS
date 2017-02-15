//
//  LoginViewController.m
//  Moment
//
//  Created by lenservice on 16/4/22.
//  Copyright © 2016年 lenservice. All rights reserved.
//


#import "LoginViewController.h"

#import "UMSocial.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSnsService.h"

#import "LogonViewController.h"

#import "UserInfoDao.h"
//#import "UMSocialSinaSSOHandler.h"
@interface LoginViewController ()
{
    UITextField * phoneTextField;
    UITextField * nameField;
    UITextField * passwordField;
    
    UILabel * codeLab;
    
    NSInteger timeSec;

}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登陆";
    [self configUI];
    
    // Do any additional setup after loading the view.
}

-(void)configUI{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 20, 35, 40, 40)];
    imageView.image = [UIImage imageNamed:@"Icon-iPhone-4"];
    [self.view addSubview:imageView];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    
    
    
    UILabel *  phoneFixLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 85-3, imageView.frame.origin.y + 40+20, 30, 20)];
    phoneFixLab.text = @"+86";
    phoneFixLab.textColor = [UIColor blackColor];
    
    phoneFixLab.font = [UIFont systemFontOfSize:14];
    UIView * sepView = [[UIView alloc]initWithFrame:CGRectMake(phoneFixLab.frame.origin.x + phoneFixLab.frame.size.width, phoneFixLab.frame.origin.y, 1, 1)];
    sepView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(sepView.frame.origin.x + sepView.frame.size.width+5, phoneFixLab.frame.origin.y, 120, 20)];
    
    phoneTextField.placeholder = @"手机";
    phoneTextField.tintColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    [phoneTextField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:phoneFixLab];
    [self.view addSubview:sepView];
    
    [self.view addSubview:phoneTextField];
    
    
    UIView * seg1 = [[UIView alloc]initWithFrame:CGRectMake(phoneFixLab.frame.origin.x, phoneTextField.frame.origin.y+ phoneTextField.frame.size.height, 176, 1)];
    
    seg1.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    [self.view addSubview:phoneTextField];
    [self.view addSubview:seg1];
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2- 88, seg1.frame.origin.y + seg1.frame.size.height+3, 176, 40)];
    nameField.placeholder = @"密码";
    
    UIView * seg2 = [[UIView alloc]initWithFrame:CGRectMake(phoneFixLab.frame.origin.x, nameField.frame.origin.y+ nameField.frame.size.height, 176, 1)];
    seg2.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    [self.view addSubview:nameField];
    [self.view addSubview:seg2];
    

    
    [phoneTextField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [nameField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(SCREEN_WIDTH/2 - 88, seg2.frame.origin.y + seg2.frame.size.height+30,176, 40);
    // [sureButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(176/2- 13, 10, 26, 18)];
    image2.image = [UIImage imageNamed:@"dgts__ic_success"];
    [sureButton addSubview:image2];
    sureButton.layer.cornerRadius = 2;
    sureButton.layer.masksToBounds = YES;
    
    [sureButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureButton];
    
    codeLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 24, sureButton.frame.origin.y + sureButton.frame.size.height+10 , 48, 20)];
    codeLab.font = [UIFont systemFontOfSize:12];
    codeLab.textColor =  [UIColor colorWithRed:143/255.0 green:202/255.0 blue:155/255.0 alpha:1];
    codeLab.text = [NSString stringWithFormat:@"忘记密码"];
    codeLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:codeLab];
    
    UIView * seg4 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 24,codeLab.frame.origin.y + codeLab.frame.size.height, 50, 1)];
    seg4.backgroundColor = [UIColor colorWithRed:143/255.0 green:202/255.0 blue:155/255.0 alpha:1];
    [self.view addSubview:seg4];
    
    codeLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 88, seg4.frame.origin.y + seg4.frame.size.height+25 , 176, 20)];
    codeLab.font = [UIFont systemFontOfSize:12];
    codeLab.textColor =  [UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:1];

    codeLab.text = [NSString stringWithFormat:@"合作伙伴登陆Moment"];
    codeLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:codeLab];
    
    
    UIButton * sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaButton.frame = CGRectMake(((SCREEN_WIDTH- 20) - 150)/2.0, codeLab.frame.origin.y + 30, 50, 51);
    [sinaButton setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
    
    
    UIButton * qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqButton.frame = CGRectMake(((SCREEN_WIDTH- 20) - 150)/2.0+50+10, codeLab.frame.origin.y + 30, 50, 52);
    [qqButton setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    
    UIButton * wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatButton.frame = CGRectMake(((SCREEN_WIDTH- 20) - 150)/2.0+20+100, codeLab.frame.origin.y + 30, 50, 53 );
    [wechatButton setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    wechatButton.highlighted = NO;
    qqButton.highlighted = NO;
    sinaButton.highlighted = NO;
    
    
    [self.view addSubview:sinaButton];
    [self.view addSubview:qqButton];
    [self.view addSubview:wechatButton];
    qqButton.tag = 1000;
    wechatButton.tag = 2000;
    sinaButton.tag = 3000;
    [sinaButton addTarget:self action:@selector(otherLogin:) forControlEvents:UIControlEventTouchUpInside];
    [wechatButton addTarget:self action:@selector(otherLogin:) forControlEvents:UIControlEventTouchUpInside];
    [qqButton addTarget:self action:@selector(otherLogin:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)otherLogin:(UIButton *)button
{
    
    
   
    if(button.tag == 1000){
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
                //          获取微博用户名、uid、token等
        
                if (response.responseCode == UMSResponseCodeSuccess) {
        
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                   
                    NSLog(@"%@",snsAccount);
                    [UserInfoDao saveIsLoginState:YES];
                   // NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                 NSDictionary *userInfo = @{@"icon":snsAccount.iconURL,@"username":snsAccount.userName};
                    [UserInfoDao saveUserInfo:userInfo];
                    LogonViewController *vc = [[LogonViewController alloc]init];
                    vc.userInfo = userInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }});
        
        
        
    }
    else if (button.tag == 2000){
       
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                
                NSLog(@"%@",snsAccount);
                [UserInfoDao saveIsLoginState:YES];
                // NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                NSDictionary *userInfo = @{@"icon":snsAccount.iconURL,@"username":snsAccount.userName};
                [UserInfoDao saveUserInfo:userInfo];
                LogonViewController *vc = [[LogonViewController alloc]init];
                vc.userInfo = userInfo;
                [self.navigationController pushViewController:vc animated:YES];

            }
            
        });
    }
    else{
        
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"%@",snsAccount);
            [UserInfoDao saveIsLoginState:YES];
            // NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSDictionary *userInfo = @{@"icon":snsAccount.iconURL,@"username":snsAccount.userName};
            [UserInfoDao saveUserInfo:userInfo];
            LogonViewController *vc = [[LogonViewController alloc]init];
            vc.userInfo = userInfo;
            [self.navigationController pushViewController:vc animated:YES];

            
        }});
        
    }
}


#pragma mark - 时间处理
-(void)sureButtonClicked:(UIButton *)button{
  
    NSLog(@"登陆");

}






-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [phoneTextField endEditing:YES];
    [nameField endEditing:YES];
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
