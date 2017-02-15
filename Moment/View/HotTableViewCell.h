//
//  HotTableViewCell.h
//  LenS_YueDong
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *musicIcon;
@property (strong, nonatomic) IBOutlet UILabel *musicName;
@property (strong, nonatomic) IBOutlet UILabel *musicInfo;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *musicIConBtn;

@end
