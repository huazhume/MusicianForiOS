//
//  MSuperViewController.m
//  Moment
//
//  Created by lenservice on 16/4/24.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "MSuperViewController.h"

@interface MSuperViewController ()

@end

@implementation MSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // UIBarButtonItem *returnButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_arrow_back_black_24dp"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClicked)];
    
    //self.navigationItem.leftBarButtonItem = returnButton;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
}

-(void)leftButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
