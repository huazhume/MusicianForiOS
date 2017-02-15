//
//  SuperTableViewController.m
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import "SuperTableViewController.h"

@interface SuperTableViewController ()

@end

@implementation SuperTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置navagationBar rightBar
    
   // UIBarButtonItem *returnButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClicked)];
    
 //   self.navigationItem.leftBarButtonItem = returnButton;


    [[UIImage imageNamed:@""]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIFont *font = [UIFont systemFontOfSize:12];
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    
}

-(void)leftButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
