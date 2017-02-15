//
//  LoadingAnimation.m
//  Progross
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 lenservice. All rights reserved.
//

#import "LoadingAnimation.h"

@interface LoadingAnimation()
@property(nonatomic ,strong)NSTimer * timer;
@end
@implementation LoadingAnimation
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self LoadingAnimation];
    }
    return self;
}

-(void)LoadingAnimation{
    for(int i = 0;i<3;i++){
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+i*(6+2)-12,SCREEN_HEIGHT/2-50, 6, 6)];
        view1.backgroundColor = [UIColor grayColor];
        view1.tag = 1000+i;
        [self addSubview:view1];
    }
    [self startTimer];
}
-(void)startTimer{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    
    }
}
-(void)timerRun{
    static NSInteger indexTag = 1000;
    UIView * view1 = [self viewWithTag:indexTag];
    view1.backgroundColor = [UIColor blackColor];
    NSLog(@"%ld",indexTag);
    
    if(indexTag >1000){
        NSInteger num = indexTag;
        UIView * view1 = [self viewWithTag:--num];
        view1.backgroundColor = [UIColor grayColor];
    }
    else if(indexTag == 1000){
        UIView * view1 = [self viewWithTag:1002];
        view1.backgroundColor = [UIColor grayColor];
    }
    
    indexTag ++;
    if(indexTag ==1003){
        indexTag = 1000;
    }
}
-(void)timerStop{
    [_timer invalidate];
    _timer = nil;
}

@end
