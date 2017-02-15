//
//  RegistViewController.m
//  Moment
//
//  Created by lenservice on 16/4/22.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "RegistViewController.h"
#import "AVOSCloud.h"
#import "RegisIsTureViewController.h"

@interface RegistViewController ()<UITextFieldDelegate>
{
    UILabel * phoneFixLab ;
    UITextField * phoneTextField;
    UIButton * yanzhengButton;
}


@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"注册";
    [self configUI];
    // Do any additional setup after loading the view.
}




#pragma mark- 初始化界面
//注册界面
-(void)configUI{
    
    phoneFixLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 85-3, SCREEN_HEIGHT/2-200, 30, 20)];
    phoneFixLab.text = @"+86";
    phoneFixLab.textColor = [UIColor blackColor];
    
    phoneFixLab.font = [UIFont systemFontOfSize:14];
    UIView * sepView = [[UIView alloc]initWithFrame:CGRectMake(phoneFixLab.frame.origin.x + phoneFixLab.frame.size.width, phoneFixLab.frame.origin.y, 1, 20)];
    sepView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(sepView.frame.origin.x + sepView.frame.size.width+5, phoneFixLab.frame.origin.y, 120, 20)];
    
    phoneTextField.placeholder = @"输入手机号";
    phoneTextField.tintColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    [phoneTextField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:phoneFixLab];
    [self.view addSubview:sepView];
    phoneTextField.delegate = self;
    [self.view addSubview:phoneTextField];
    
    
    UIView * sepview2 = [[UIView alloc]initWithFrame:CGRectMake(phoneFixLab.frame.origin.x, phoneFixLab.frame.origin.y + phoneFixLab.frame.size.height + 4, 176, 1)];
    sepview2.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    [self.view addSubview:sepview2];
    
    
    yanzhengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yanzhengButton.frame = CGRectMake(SCREEN_WIDTH/2 - 88, sepview2.frame.origin.y + 15, 176, 35);
    yanzhengButton.backgroundColor = [UIColor blackColor];
    yanzhengButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [yanzhengButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    
    [self.view addSubview:yanzhengButton];
    yanzhengButton.layer.cornerRadius = 2;
    yanzhengButton.layer.masksToBounds = YES;
    
    [yanzhengButton addTarget:self action:@selector(sendVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * tishiLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 88, yanzhengButton.frame.origin.y+ yanzhengButton.frame.size.height + 15, 176, 14)];
    tishiLab.textColor = [UIColor colorWithRed:143/255.0 green:202/255.0 blue:155/255.0 alpha:1];;
    tishiLab.font = [UIFont systemFontOfSize:12];
    tishiLab.text = @"注册代表你已阅读并同意协议";
    tishiLab.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:tishiLab];
    
    
    UILabel * tishiLab2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 88, SCREEN_HEIGHT - 250, 176, 100)];
    tishiLab2.font = [UIFont systemFontOfSize:12];
    tishiLab2.textColor = [UIColor colorWithRed:143/255.0 green:202/255.0 blue:155/255.0 alpha:1];;
    tishiLab2.text = @"您将收到验证身份的短信。手机注册将有效避免垃圾广告，骚扰信息。片刻绝对不会在任何途径泄露您的手机号码和个人信息.";
    tishiLab2.numberOfLines = 0;
    [self.view addSubview:tishiLab2];
    
    
}
#pragma mark －时间处理 发送验证码
-(void)sendVerificationCode:(UIButton *)button{
    [phoneTextField endEditing:YES];
    
    
    NSString * phoneStr = phoneTextField.text;
    if(phoneStr.length == 11 && ([phoneStr hasPrefix:@"13"]||[phoneStr hasPrefix:@"15"]||[phoneStr hasPrefix:@"17"]||[phoneStr hasPrefix:@"17"]||[phoneStr hasPrefix:@"18"])){
        [self getCodeClicked];
           }
    else{
    
        UIAlertView * alrtView = [[UIAlertView alloc]initWithTitle:@"" message:@"手机号码不正确 请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alrtView show];
        phoneTextField.text = @"";
    }
}



-(void)getCodeClicked{
    [AVOSCloud requestSmsCodeWithPhoneNumber:phoneTextField.text appName:@"Moment"operation:@"注册操作" timeToLive:3 callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

            RegisIsTureViewController * regVC = [RegisIsTureViewController new];
            regVC.phoneNumber = phoneTextField.text;
            [self.navigationController pushViewController:regVC animated:YES];

        }else{
            NSLog(@"err %@",error.userInfo[@"error"]);
            UIAlertView * alrtView = [[UIAlertView alloc]initWithTitle:@"" message:@"验证码获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alrtView show];

        }
        // 执行结果
    }];

}

//验证是否正确
-(void)test{
  //  [AVOSCloud verifySmsCode:_passwordTextfield.text mobilePhoneNumber:_userTextfield.text callback:^(BOOL succeeded, NSError *error) {
        
                    
   //     }];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [phoneTextField endEditing:YES];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

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
