//
//  ModelManager.m
//  Moment
//
//  Created by lenservice on 16/4/26.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "ModelManager.h"
#import "ManagerStore.h"
#import "MusicPo.h"
#import <CoreData/CoreData.h>

@implementation ModelManager


//保存
-(void)saveMusicModelVo:(MusicModel *)musicVo{
    
    MusicPo * newM = [NSEntityDescription insertNewObjectForEntityForName:@"MusicPo" inManagedObjectContext:[ManagerStore sharedInstance].managedObjectContext ];
    [self translatebyPO:newM ByMusicVO:musicVo];
    [[ManagerStore sharedInstance] saveContext];
    
    
}
//查询全部
-(NSArray *)readAll{
   
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"MusicPo"];
    NSArray * result = [[ManagerStore sharedInstance].managedObjectContext executeFetchRequest:request error:nil];
    
    NSMutableArray * voArr = [[NSMutableArray alloc]init];
    [result enumerateObjectsUsingBlock:^(MusicPo * po, NSUInteger idx, BOOL * _Nonnull stop) {
        MusicModel * vo = [self translateToMusicVobymusicPo:po];
        [voArr addObject: vo];
    }];
    NSLog(@"___________________%@",voArr);
    return voArr;
}
//查询是否存在
-(BOOL)getIsSaveBySongID:(NSNumber *)songId{
   
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"MusicPo"];
    request.predicate = [NSPredicate predicateWithFormat:@"songid = %@",songId];
    
    NSArray * fetchResult = [[ManagerStore sharedInstance].managedObjectContext executeFetchRequest:request error:nil];
    if(fetchResult.count > 0){
        return YES;
    }
    
    return NO;
}

-(void)translatebyPO:(MusicPo *)po ByMusicVO:(MusicModel *)vo{
    po.songid = vo.songid;
    po.downUrl = vo.downUrl;
    po.singerid = vo.singerid;
    po.albumid = vo.albumid;
    po.alumname = vo.albumname;
    po.singername = vo.singername;
    po.songname = vo.songname;
    po.url = vo.url;
    po.imageUrl = vo.imageUrl;
    po.albumpic_big = vo.albumpic_big;
    po.m4a = vo.m4a;
}


-(MusicModel *)translateToMusicVobymusicPo:(MusicPo *)po{
  
    MusicModel * vo = [[MusicModel alloc]init];
    vo.songid = po.songid;
    vo.downUrl = po.downUrl;
    vo.singerid = po.singerid;
    vo.albumid = po.albumid;
    vo.albumname = po.alumname;
    vo.singername = po.singername;
    vo.songname = po.songname;
    vo.url = po.url;
    vo.imageUrl = po.imageUrl;
    vo.albumpic_big = po.albumpic_big;
    vo.m4a = po.m4a;
   
    return vo;
}


@end
