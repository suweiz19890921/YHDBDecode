//
//  HQDatabaseManager.h
//  CameraRuler
//
//  Created by LiuHuanQing on 15/4/3.
//  Copyright (c) 2015年 HQ_L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "HQModelMetadate.h"

//#define DATA_DB @"fishdata.db"
//#define DEFAULT_DB_QUEUE [[HQDatabaseManager sharedInstance] dbQueueWithName:DATA_DB] //默认的数据库队列
@interface HQDatabaseManager : NSObject
+ (instancetype)sharedInstance;

/**
 *  创建一个FMDatabaseQueue
 *
 *  @param dbName 库名
 */
- (void)createDBQueue:(NSString *)dbName;

/**
 *  获得一个FMDatabaseQueue
 *
 *  @param dbName 库名
 *
 *  @return FMDatabaseQueue实例
 */
- (FMDatabaseQueue *)dbQueueWithName:(NSString *)dbName;


/**
 *  保存一个HQModelMetadate对象
 *
 *  @param dbModelMetadate HQModelMetadate 实例
 *  @param class           类对象
 */
- (void)setMetadate:(HQModelMetadate *)dbModelMetadate forClass:(Class)class;

/**
 *  获得一个HQModelMetadate对象
 *
 *  @param class 类对象
 *
 *  @return HQModelMetadate 实例
 */
- (HQModelMetadate *)dbModelMetadate:(Class)class;

/**
 *  创建一个库同时创建所需要的表
 *
 *  @param dbName 库名称
 *  @param array  HQModel的类对象
 */
- (void)createDBQueue:(NSString *)dbName withTalbe:(NSArray *)array;
/**
 *  通过类型获取所存放的库
 *
 *  @param class 类型
 *
 *  @return 库
 */
- (FMDatabaseQueue *)getDBQueueWithClass:(Class)class;

@end
