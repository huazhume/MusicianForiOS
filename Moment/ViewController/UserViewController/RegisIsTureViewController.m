//
//  RegisIsTureViewController.m
//  Moment
//
//  Created by lenservice on 16/4/22.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "RegisIsTureViewController.h"
#import "AVOSCloud.h"
#import "UserInfoDao.h"

@interface RegisIsTureViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    UITextField * phoneField;
    UITextField * nameField;
    UITextField * passwordField;
    
    UILabel * codeLab;
    
    NSInteger timeSec;
    UIButton * button ;
    NSString * filePath;
}

@property(nonatomic ,strong)NSTimer * timer;
@end

@implementation RegisIsTureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationItem.title = @"注册";
    timeSec = 59;
    [self configUI];
    // Do any additional setup after loading the view.
}

#pragma mark - 配置文件
-(void)configUI{
    
    //UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, 50, 80, 85)];
    //imageView.image = [UIImage imageNamed:@"10B10243-761D-4642-98E2-29D2349CCD72.png"];
    //[self.view addSubview:imageView];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH/2 - 40, 50, 80, 85);
    
    button.layer.cornerRadius = 42;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"10B10243-761D-4642-98E2-29D2349CCD72.png"] forState:UIControlStateNormal];
    [button setTitle:@"选择头像" forState:UIControlStateNormal];
    [button  setTitleColor:[UIColor colorWithRed:143/255.0 green:202/255.0 blue:155/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    phoneField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2- 88, button.frame.origin.y + button.frame.size.height + 30, 176, 40)];
    phoneField.placeholder = @"手机验证码";
    
    UIView * seg1 = [[UIView alloc]initWithFrame:CGRectMake(phoneField.frame.origin.x, phoneField.frame.origin.y+ phoneField.frame.size.height, 176, 1)];
    seg1.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    [self.view addSubview:phoneField];
    [self.view addSubview:seg1];
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2- 88, seg1.frame.origin.y + seg1.frame.size.height, 176, 40)];
    nameField.placeholder = @"昵称(2-10字)";
    
    UIView * seg2 = [[UIView alloc]initWithFrame:CGRectMake(phoneField.frame.origin.x, nameField.frame.origin.y+ nameField.frame.size.height, 176, 1)];
    seg2.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    [self.view addSubview:nameField];
    [self.view addSubview:seg2];
    
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2- 88, seg2.frame.origin.y + seg2.frame.size.height, 176, 40)];
    passwordField.placeholder = @"密码";
    
    UIView * seg3 = [[UIView alloc]initWithFrame:CGRectMake(phoneField.frame.origin.x, passwordField.frame.origin.y+ passwordField.frame.size.height, 176, 1)];
    seg3.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    [self.view addSubview:passwordField];
    [self.view addSubview:seg3];
    
     [phoneField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
     [passwordField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
     [nameField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(SCREEN_WIDTH/2 - 88, seg3.frame.origin.y + seg3.frame.size.height+30,176, 40);
   // [sureButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(176/2- 13, 10, 26, 18)];
    image2.image = [UIImage imageNamed:@"dgts__ic_success"];
    [sureButton addSubview:image2];
    sureButton.layer.cornerRadius = 2;
    sureButton.layer.masksToBounds = YES;
    
    [sureButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureButton];
    
    codeLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 88, sureButton.frame.origin.y + sureButton.frame.size.height+10 , 176, 20)];
    codeLab.font = [UIFont systemFontOfSize:12];
    codeLab.textColor =  [UIColor colorWithRed:143/255.0 green:202/255.0 blue:155/255.0 alpha:1];
    codeLab.text = [NSString stringWithFormat:@"59秒后可接受新验证码"];
    codeLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:codeLab];
    
    UIView * seg4 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 60,codeLab.frame.origin.y + codeLab.frame.size.height, 120, 1)];
    seg4.backgroundColor = [UIColor colorWithRed:143/255.0 green:202/255.0 blue:155/255.0 alpha:1];
    [self.view addSubview:seg4];
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [nameField endEditing:YES];
    [phoneField endEditing:YES];
    [passwordField endEditing:YES];
}

-(void)buttonClicked:(UIButton *)button{
  //  UIActionSheetStyle
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择照片", nil];

    [sheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    NSLog(@"%ld",buttonIndex);
    if(buttonIndex == 0){
        //拍照
        [self takePhoto];
    }
    else if (buttonIndex == 1){
        //选择照片
        [self LocalPhoto];
    }

}

/***********picker的代理方法************/
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    
    
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        
        NSString * nameStr = [NSString stringWithFormat:@"/%d.png",arc4random_uniform(1000000)];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:nameStr] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,nameStr];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
    }
    
}

#pragma mark -
#pragma mark 从本地获取图片
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"无法打开照相机");
    }
}



-(void)sureButtonClicked:(UIButton *)button{
    [nameField endEditing:YES];
    [phoneField endEditing:YES];
    [passwordField endEditing:YES];
    if((![nameField.text isEqualToString:@""]&&nameField.text != nil)&&((![nameField.text isEqualToString:@""]&&nameField.text != nil))&&(![nameField.text isEqualToString:@""]&&nameField.text != nil)){
        
          [AVOSCloud verifySmsCode:phoneField.text mobilePhoneNumber:self.phoneNumber callback:^(BOOL succeeded, NSError *error) {
              if(succeeded){
                  
                  UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                  alert.tag = 1000;
                  [alert show];
                  
                  NSDictionary * dic = @{@"icon": filePath,@"username":nameField.text,@"password":passwordField.text};
                  [UserInfoDao saveIsLoginState:YES ];
                  [UserInfoDao saveUserInfo:dic];
                  
              }
              else{
              
                  UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"验证码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                  [alert show];
              }
        
             }];

    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请填写完整资料" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1000){
        if(buttonIndex == 0){
            
        //    NSDictionary * dic  = [UserInfoDao getUserInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
}


-(void)startTimer{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    }
    
}
-(void)timerRun{
    timeSec--;
    codeLab.text = [NSString stringWithFormat:@"%ld秒后可接受新验证码",timeSec];
    if(timeSec==0){
        [self timerStop];
        codeLab.text = [NSString stringWithFormat:@"返回重新接受新验证码"];
    }
    
}
-(void)timerStop{
    [_timer invalidate];
    _timer = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [self startTimer];
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
