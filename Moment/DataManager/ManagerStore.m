//
//  ManagerStore.m
//  Moment
//
//  Created by lenservice on 16/4/26.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "ManagerStore.h"

@interface ManagerStore ()
@property (readonly ,strong, nonatomic)NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (readonly ,strong, nonatomic)NSManagedObjectModel * managedObjectmodel;

@end

@implementation ManagerStore
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectmodel = _managedObjectmodel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+(instancetype)sharedInstance{
    static ManagerStore * _shareManagerStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManagerStore = [[self alloc]init];
    });
    
    return _shareManagerStore;
}


-(void)saveContext{
    NSError * error = nil;
    NSManagedObjectContext * managedObjectContext = _managedObjectContext;
    if(managedObjectContext != nil){
        if([managedObjectContext hasChanges]&&![managedObjectContext save:&error]){
            NSLog(@"Unresolved Error %@, %@",error , [error userInfo]);
        }
        else{
            NSLog(@"数据成功插入");
        }
    }
}

-(NSURL *)applicationDocumentsDirectory{
    
    NSURL * url = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
   
    return url;
}

/**
 *  加载托管模型
 *
 *  @return MSManagedObjectModel
 */
-(NSManagedObjectModel *)managedObjectmodel{
    if(_managedObjectmodel != nil){
        return _managedObjectmodel;
    }
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"ModelPO" withExtension:@"momd"];
    _managedObjectmodel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelUrl];
    return _managedObjectmodel;
}

/**
 *  创建持久化协调器
 *
 *  @return NSPerdistentStoreCoordinator
 *
 */
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if(_persistentStoreCoordinator != nil){
        return _persistentStoreCoordinator;
    }
    
    //链接数据库 备数据存储
    NSURL * storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ModelPO.aqlite"];
    NSLog(@"storeUrl == %@",storeUrl);
    
    //持久化存储调度器由托管对象模型初始化
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectmodel]];
    
    NSError * error = nil;
    
    //设置持久化存储类型为sqlite并指定sqlite数据库文件的路径
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]){
        NSLog(@"Unresolved error %@ , %@",error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}
/**
 *  创建托管对象上下文
 *
 *  @return NSManagedObjectContext
 */

-(NSManagedObjectContext *)managedObjectContext{
   
    if(_managedObjectContext != nil){
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator * coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil){
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    }
    return _managedObjectContext;
}






@end
