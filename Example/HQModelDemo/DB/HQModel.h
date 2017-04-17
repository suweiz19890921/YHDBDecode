//
//  HQModel.h
//  CameraRuler
//
//  Created by LiuHuanQing on 15/4/3.
//  Copyright (c) 2015年 HQ_L. All rights reserved.
//

#import "JSONModel.h"
#import <FMDB/FMDB.h>

//主键
@protocol PrimaryKey
@end

////联合主键
//@protocol PrimaryKeys
//@end

//唯一
@protocol Unique
@end

//自增主键
@protocol AutoPrimary
@end

@interface NSObject(HQModelPropertyCompatibility)<PrimaryKey, Unique, AutoPrimary>
@end


@interface HQModel : JSONModel

+ (instancetype)dataWithJSON:(NSDictionary *)dict;

+ (instancetype)dataWithString:(NSString *)string;

+ (NSString *)idGenerotor;
/**
 *  解析FMResultSet
 *
 *  @param rs FMResultSet 实例
 *
 *  @return HQModel 实例
 */
- (instancetype)initWithResultSet:(FMResultSet *)rs;
- (instancetype)initWithResultSet1:(FMResultSet *)rs;
/**
 *  返回建表的sql语句
 *
 *  @return 字符串
 */
+ (NSString *)create;

/**
 *  插入语句
 *
 *  @return sql语句
 */
+ (NSString *)insert;

/**
 *  插入一条属性值
 *
 *  @return 成功标志
 */
- (BOOL)insert;

/**
 *  拿到所有属性值
 *
 *  @return obj的NSArray
 */
+ (NSArray *)all;

+ (NSArray *)allTest;
/**
 *  批量插入
 *
 *  @param dataSource obj的NSArray
 *
 *  @return 成功标志
 */
+ (BOOL)insertAll:(NSArray *)dataSource;

/**
 *  删除一条属性值
 *
 *  @return 成功标志
 */
- (BOOL)delete;

/**
 *  删除所有数据
 *
 *  @return 成功YES
 */
+ (BOOL)deleteAll;

/**
 *  删除数组内数据
 *
 *  @return 成功YES
 */
+ (BOOL)deleteArray:(NSArray *)datas;

/**
 *  根据属性删除属性值
 *
 *  @param propertyName         属性名
 *  @param propertyValue        属性值
 *
 *  @return 成功标志
 */
+ (BOOL)deleteByProperty:(NSString *)propertyName propertyValue:(id)propertyValue;

/**
 *  通过多个属性做删除操作
 *
 *  @param propertyMaps 属性键值对
 *
 *  @return 结果
 */
+ (BOOL)deleteByPropertyMaps:(NSDictionary *)propertyMaps;

+ (BOOL)deleteByWHERE:(NSString *)where propertyMaps:(NSDictionary *)propertyMaps;

+ (BOOL)update:(NSString *)SQL;
/**
 *  更新属性值的某个字段
 *
 *  @param propertyName         属性名
 *  @param propertyValue        属性值
 *
 *  @return 成功标志
 */
- (BOOL)updateByProperty:(NSString *)propertyName propertyValue:(id)propertyValue;

/**
 *  根据主键更新的某个字段
 *
 *  @param propertyName         属性名
 *  @param propertyValue        属性值
 *  @param keyValue             主键值
 *
 *  @return 成功标志
 */
+ (BOOL)updateByProperty:(NSString *)propertyName propertyValue:(id)propertyValue keyValue:(id)keyValue;

/**
 *  根据多条属性修改多条属性
 *
 *  @param whereMaps       条件
 *  @param setMaps 要更新的属性
 *
 *  @return 成功标志
 */
+ (BOOL)updateBySetMaps:(NSDictionary *)setMaps whereMaps:(NSDictionary *)whereMaps;

+ (BOOL)updateByWHERE:(NSString *)sql propertyName:(NSString *)propertyName propertyValue:(id)propertyValue;

+ (BOOL)updateBySQL:(NSString *)SQL propertyMaps:(NSDictionary *)propertyMaps;
/**
 *  根据属性查询属性值
 *
 *  @param propertyName         属性名称
 *  @param propertyValue        属性值
 *
 *  @return 对象数组
 */
+ (NSArray *)selectByProperty:(NSString *)propertyName propertyValue:(id)propertyValue;

/**
 *  根据多条属性查询
 *
 *  @param propertys 属性键值对
 *
 *  @return 对象数组
 */
+ (NSArray *)selectByPropertyMaps:(NSDictionary *)selectByPropertyMaps;


+ (NSArray *)selectBySQL:(NSString *)sql;

+ (NSArray *)selectBySQL:(NSString *)sql propertyMaps:(NSDictionary *)propertyMaps;


+ (NSArray *)selectByWHERE:(NSString *)sql propertyMaps:(NSDictionary *)propertyMaps;

- (NSDictionary *)toModleDictionary;


//-----
+ (BOOL)propertyIsAutoPrimary:(NSString *)propertyName;

+ (BOOL)propertyIsPrimaryKey:(NSString *)propertyName;

//+ (BOOL)propertyIsPrimaryKeys:(NSString *)propertyName;


@end
