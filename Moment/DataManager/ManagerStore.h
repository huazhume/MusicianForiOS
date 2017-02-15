//
//  ManagerStore.h
//  Moment
//
//  Created by lenservice on 16/4/26.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ManagerStore : NSObject
//数据管理属性
@property (readonly ,strong ,nonatomic)NSManagedObjectContext * managedObjectContext;
//单例
+(instancetype)sharedInstance;
//保存内容
-(void)saveContext;

@end
