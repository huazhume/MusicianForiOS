//
//  ModelManager.h
//  Moment
//
//  Created by lenservice on 16/4/26.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MusicModel.h"

@interface ModelManager : NSObject

-(void)saveMusicModelVo:(MusicModel *)musicVo;

-(NSArray *)readAll;

-(BOOL)getIsSaveBySongID:(NSNumber *)songId;
@end
