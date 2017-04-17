//
//  HQModelMetadate.h
//  CameraRuler
//
//  Created by LiuHuanQing on 15/4/3.
//  Copyright (c) 2015年 HQ_L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQModelMetadate : NSObject
@property (nonatomic,strong) NSArray  *propertys;//HQModelClassProperty类型的数组
@property (nonatomic,strong) NSString *primaryKey;//主键名称
@property (nonatomic,strong) NSString *createSQL;//建表语句
@property (nonatomic,strong) NSString *insertSQL;//插入语句
@property (nonatomic,strong) NSString *delectSQL;//删除语句
@property (nonatomic,strong) NSString *dbName;    //所属库

/**
 *  生成DBModelMetadate
 *
 *  @param class 类对象
 *
 *  @return DBModelMetadate
 */
- (instancetype)initWithClass:(Class)class;
@end
