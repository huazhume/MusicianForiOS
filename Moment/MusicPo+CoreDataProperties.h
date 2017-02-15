//
//  MusicPo+CoreDataProperties.h
//  Moment
//
//  Created by lenservice on 16/4/26.
//  Copyright © 2016年 lenservice. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MusicPo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MusicPo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *songid;
@property (nullable, nonatomic, retain) NSString *downUrl;
@property (nullable, nonatomic, retain) NSNumber *singerid;
@property (nullable, nonatomic, retain) NSString *alumname;
@property (nullable, nonatomic, retain) NSString *singername;
@property (nullable, nonatomic, retain) NSNumber *albumid;
@property (nullable, nonatomic, retain) NSString *songname;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *albumpic_big;
@property (nullable, nonatomic, retain) NSString *m4a;

@end

NS_ASSUME_NONNULL_END
