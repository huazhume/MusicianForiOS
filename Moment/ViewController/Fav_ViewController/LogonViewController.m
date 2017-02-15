//
//  LogonViewController.m
//  Moment
//
//  Created by lenservice on 16/4/25.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "LogonViewController.h"
#import "LogonTableViewCell.h"
#import "UIButton+WebCache.h"
#import "SetViewController.h"
#import "UserInfoDao.h"
#import "BriefIntroViewController.h"


#import "MytingTableViewController.h"

#define ProSize 800/1280.0

@interface LogonViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSArray * _dataList;
    NSArray * _dataList2;
    
    UIImageView * backImageView;
    UILabel * userNameLab;
    UIButton * userIcon;
    
    NSString * filePath;
    

}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation LogonViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LogonTableViewCell class] forCellReuseIdentifier:@"logonCell"];
    NSDictionary * dic = [UserInfoDao getUserInfo];
    NSString * str = dic[@"brief"];
    if((str != nil)&&![str isEqualToString:@""]){
        _dataList = @[@{@"title" : @"简介",@"deTitle":str},@{@"title" : @"认证",@"deTitle":@""},@{@"title": @"更多",@"deTitle":@"基本信息"}];
    }
    else{
        _dataList = @[@{@"title" : @"简介",@"deTitle":@""},@{@"title" : @"认证",@"deTitle":@""},@{@"title": @"更多",@"deTitle":@"基本信息"}];
    }
    
    _dataList2 = @[@{},@{}];
    [self configUI];
    // Do any additional setup after loading the view.
}

#pragma mark - 
#pragma mark 配置界面
-(void)configUI{
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView * bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH* ProSize)];

    backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH* ProSize)];
    backImageView.image = [UIImage imageNamed:@"Untitled2.jpg"];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH* ProSize)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.1;
    userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 80, 30)];
    userNameLab.font = [UIFont boldSystemFontOfSize:16];
    userNameLab.textColor = [UIColor whiteColor];
    userNameLab.text = _userInfo[@"username"];
    [bg addSubview:backImageView];
    [backImageView addSubview:backView];
    [bg addSubview:userNameLab];
    
    UIButton * setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(SCREEN_WIDTH- 20 - 23, 15, 23, 23);
    [setButton setBackgroundImage:[UIImage imageNamed:@"icon-shezhi"] forState:UIControlStateNormal];
    [bg addSubview:setButton];
    
    UIView * sepView = [[UIView alloc]initWithFrame:CGRectMake(20, userNameLab.frame.origin.y + 30, SCREEN_WIDTH- 40, 2)];
    sepView.backgroundColor = [UIColor whiteColor];
    [bg addSubview:sepView];
    
    userIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    userIcon.frame = CGRectMake(SCREEN_WIDTH/2 - 35, sepView.frame.origin.y + 20, 70, 70);
    
    if([_userInfo[@"icon"] hasPrefix:@"http:"]){
        
        [userIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:_userInfo[@"icon"]] forState:UIControlStateNormal];
    }
    else{
        
        NSLog(@"%@",_userInfo[@"icon"]);
        [userIcon setBackgroundImage:[UIImage imageWithContentsOfFile:_userInfo[@"icon"]] forState:UIControlStateNormal];
    }
   
    userIcon.layer.cornerRadius = 35;
    userIcon.layer.masksToBounds = YES;

    [bg addSubview:userIcon];
    
    UIButton * followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followButton.frame = CGRectMake((SCREEN_WIDTH - 210)/2.0, userIcon.frame.origin.y + userIcon.frame.size.height + 20, 70,  SCREEN_WIDTH* ProSize - (userIcon.frame.origin.y + userIcon.frame.size.height + 20)- 20);
    followButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [followButton setTitle:@"关注\n0" forState:UIControlStateNormal];
    [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIView * sep1 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 210)/2.0+70, userIcon.frame.origin.y + userIcon.frame.size.height + 20, 0.5, followButton.frame.size.height)];
    sep1.backgroundColor = [UIColor whiteColor];
    
    UIButton * fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fansButton.frame = CGRectMake((SCREEN_WIDTH - 210)/2.0+70, userIcon.frame.origin.y + userIcon.frame.size.height + 20, 70,  SCREEN_WIDTH* ProSize - (userIcon.frame.origin.y + userIcon.frame.size.height + 20)- 20);
    fansButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [fansButton setTitle:@"粉丝\n0" forState:UIControlStateNormal];
    [fansButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIView * sep2 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 210)/2.0+70+70, userIcon.frame.origin.y + userIcon.frame.size.height + 20, 0.5, followButton.frame.size.height)];
    sep2.backgroundColor = [UIColor whiteColor];
    
    UIButton * visitorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    visitorButton.frame = CGRectMake((SCREEN_WIDTH - 210)/2.0+70+70, userIcon.frame.origin.y + userIcon.frame.size.height + 20, 70,  SCREEN_WIDTH* ProSize - (userIcon.frame.origin.y + userIcon.frame.size.height + 20)- 20);
    visitorButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [visitorButton setTitle:@"访客\n0" forState:UIControlStateNormal];
    [visitorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    followButton.titleLabel.numberOfLines = 0;
    fansButton.titleLabel.numberOfLines = 0;
    visitorButton.titleLabel.numberOfLines = 0;
    followButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    fansButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    visitorButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [bg addSubview:followButton];
    [bg addSubview:fansButton];
    [bg addSubview:visitorButton];
    [bg addSubview:sep1];
    [bg addSubview:sep2];
    setButton.tag = 1000;
    userIcon.tag = 2000;
    [setButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [userIcon addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return bg;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_WIDTH * ProSize;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    bgView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    UIView * top1View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    top1View.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];

    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, SCREEN_WIDTH, 0.5)];
    topView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
    UIButton * myshouluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myshouluBtn.frame = CGRectMake(0, 10, SCREEN_WIDTH/3.0, 60);
    [myshouluBtn setImage:[UIImage imageNamed:@"收录"] forState:UIControlStateNormal];
    [myshouluBtn setImageEdgeInsets:UIEdgeInsetsMake(10, (SCREEN_WIDTH/3.0 - 35)/2, 20, (SCREEN_WIDTH/3.0 - 35)/2)];
    myshouluBtn.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:topView];
    [bgView addSubview:top1View];
    [bgView addSubview:myshouluBtn];
 
    [myshouluBtn setTitle:@"我的收录" forState:UIControlStateNormal];
    [myshouluBtn setTitleColor:[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1] forState:UIControlStateNormal];
    myshouluBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [myshouluBtn setTitleEdgeInsets:UIEdgeInsetsMake(10+30, -SCREEN_WIDTH/5.0, 0, 0)];
    
    myshouluBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView * sep1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0, 10, 0.5, 60)];
    sep1.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
    UIButton * favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favBtn.frame = CGRectMake(SCREEN_WIDTH/3.0, 10, SCREEN_WIDTH/3.0, 60);
    [favBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
    [favBtn setImageEdgeInsets:UIEdgeInsetsMake(10, (SCREEN_WIDTH/3.0 - 35)/2, 20, (SCREEN_WIDTH/3.0 - 35)/2)];
    favBtn.backgroundColor = [UIColor whiteColor];
    
    [bgView addSubview:favBtn];
    
    [favBtn setTitle:@"我的喜欢" forState:UIControlStateNormal];
    [favBtn setTitleColor:[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1] forState:UIControlStateNormal];
    favBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [favBtn setTitleEdgeInsets:UIEdgeInsetsMake(10+30, -SCREEN_WIDTH/5.0, 0, 0)];
    favBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView * sep2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0*2, 10, 0.5, 60)];
    sep2.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    

    UIButton * downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame = CGRectMake(0+SCREEN_WIDTH/3.0*2, 10, SCREEN_WIDTH/3.0, 60);
    [downBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
    [downBtn setImageEdgeInsets:UIEdgeInsetsMake(10, (SCREEN_WIDTH/3.0 - 35)/2, 20, (SCREEN_WIDTH/3.0 - 35)/2)];
    downBtn.backgroundColor = [UIColor whiteColor];
    
    [bgView addSubview:downBtn];
    
    [downBtn setTitle:@"我的下载" forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1] forState:UIControlStateNormal];
    downBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [downBtn setTitleEdgeInsets:UIEdgeInsetsMake(10+30, -SCREEN_WIDTH/4.0, 0, 0)];
    downBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView * boView = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5+10, SCREEN_WIDTH, 0.5)];
    boView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [bgView addSubview:boView];
    [bgView addSubview:sep1];
    [bgView addSubview:sep2];
    
    UIView * top2View = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, SCREEN_WIDTH, 0.5)];
    top2View.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
    UIButton * musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    musicBtn.frame = CGRectMake(0, 80, SCREEN_WIDTH/3.0, 60);
    [musicBtn setImage:[UIImage imageNamed:@"碎片"] forState:UIControlStateNormal];
    [musicBtn setImageEdgeInsets:UIEdgeInsetsMake(10, (SCREEN_WIDTH/3.0 - 35)/2, 20, (SCREEN_WIDTH/3.0 - 35)/2)];
    musicBtn.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:top2View];
    [bgView addSubview:musicBtn];
    
    [musicBtn setTitle:@"碎片" forState:UIControlStateNormal];
    [musicBtn setTitleColor:[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1] forState:UIControlStateNormal];
    musicBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [musicBtn setTitleEdgeInsets:UIEdgeInsetsMake(10+30, -SCREEN_WIDTH/5.0, 0, 0)];
    
    musicBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView * sep3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0, 80, 0.5, 60)];
    sep3.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
    UIButton * music2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    music2Btn.frame = CGRectMake(SCREEN_WIDTH/3.0, 80, SCREEN_WIDTH/3.0, 60);
    [music2Btn setImage:[UIImage imageNamed:@"音乐"] forState:UIControlStateNormal];
    [music2Btn setImageEdgeInsets:UIEdgeInsetsMake(10, (SCREEN_WIDTH/3.0 - 35)/2, 20, (SCREEN_WIDTH/3.0 - 35)/2)];
    music2Btn.backgroundColor = [UIColor whiteColor];
    
    [bgView addSubview:music2Btn];
    
    [music2Btn setTitle:@"Ting" forState:UIControlStateNormal];
    [music2Btn setTitleColor:[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1] forState:UIControlStateNormal];
    music2Btn.titleLabel.font = [UIFont systemFontOfSize:11];
    [music2Btn setTitleEdgeInsets:UIEdgeInsetsMake(10+30, -SCREEN_WIDTH/5.0, 0, 0)];
    music2Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView * sep4 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0*2, 80, 0.5, 60)];
    sep4.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
    [bgView addSubview:sep3];
    [bgView addSubview:sep4];

    UIView * sep5 = [[UIView alloc]initWithFrame:CGRectMake(0, 139.5, SCREEN_WIDTH, 0.5)];
    sep5.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [bgView addSubview:sep5];
    
    myshouluBtn.tag = 3000;
    favBtn.tag = 4000;
    downBtn.tag = 5000;
    musicBtn.tag = 6000;
    music2Btn.tag = 7000;
    
    [myshouluBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [favBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [downBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [music2Btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [musicBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
  
    return bgView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;
}






-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"logonCell"];
    if(!cell){
        
        cell = [[LogonTableViewCell alloc]init];
    }
    
    cell.titleLab.text = _dataList[indexPath.row][@"title"];
    cell.detailTitleLab.text = _dataList[indexPath.row][@"deTitle"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

-(void)buttonClicked:(UIButton *)button{
    if(button.tag == 1000){
        //设置
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:[SetViewController new] animated:YES];
    }else if (button.tag == 2000){
        // 头像
      
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择照片", nil];
        [sheet showInView:self.view];

    }else if (button.tag == 3000){
        //我的收录
      //  [self.navigationController pushViewController:[MytingTableViewController new] animated:YES];
        
    }else if (button.tag == 4000){
        //我的喜欢
    }else if (button.tag == 5000){
        //我的下载
    }else if (button.tag == 6000){
        //碎片
    }else if (button.tag == 7000){
        //ting
    }else if (button.tag == 8000){
    
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%ld",buttonIndex);
    if(buttonIndex == 0){
        //拍照
        [self takePhoto];
    }
    else if (buttonIndex == 1){
        //选择照片
        [self localPhoto];
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
        
        [userIcon setBackgroundImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
        
        NSDictionary * dic = [UserInfoDao getUserInfo];
        NSDictionary * newDic;
        if(dic[@"brief"] == nil){
            newDic = @{@"icon":filePath,@"username":dic[@"username"]};
        }
        else{
            newDic = @{@"icon":filePath,@"username":dic[@"username"],@"brief":dic[@"brief"]};
        }
        
        [UserInfoDao saveUserInfo:newDic];
    }
    
}

#pragma mark -
#pragma mark 从本地获取图片
-(void)localPhoto
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        //简介
        BriefIntroViewController * vc = [[BriefIntroViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1){
        //认证
    }else if (indexPath.row == 2){
        //基本信息
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return YES;
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
