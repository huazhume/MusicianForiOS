//
//  LogonTableViewCell.m
//  Moment
//
//  Created by lenservice on 16/4/25.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "LogonTableViewCell.h"

@implementation LogonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, self.frame.size.height/2 - 10, 30, 20)];
        _titleLab.font = [UIFont systemFontOfSize:12];
        _titleLab.textColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1];
        
        _detailTitleLab =  [[UILabel alloc]initWithFrame:CGRectMake(20 + 30 +5, self.frame.size.height/2 - 10, self.frame.size.width- 55, 20)];
        _detailTitleLab.font = [UIFont systemFontOfSize:14];
        _detailTitleLab.textColor = [UIColor blackColor];
        
        [self addSubview:_titleLab];
        [self addSubview:_detailTitleLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
