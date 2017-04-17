//
//  HQModel.m
//  CameraRuler
//
//  Created by LiuHuanQing on 15/4/3.
//  Copyright (c) 2015年 HQ_L. All rights reserved.
//

#import "HQModel.h"
#import "HQDatabaseManager.h"
#import "HQModelClassProperty.h"
#import "objc/message.h"
#import "NSString+util.h"
#import "NSArray+util.h"
#import "NSDictionary+util.h"
#import "NSObject+HQDBDecode.h"
@implementation HQModel
+ (void)initialize
{
    Class cls = [self class];
    if (cls == [HQModel class])
    {
        return;
    }
//    [[HQDatabaseManager sharedInstance] inspectDBModel:cls];
}

+ (BOOL)propertyIsAutoPrimary:(NSString *)propertyName
{
    return NO;
}

+ (BOOL)propertyIsPrimaryKey:(NSString *)propertyName
{
    return NO;
}

+ (instancetype)dataWithJSON:(NSDictionary *)dict
{
    NSError *err;
    id data = [[self alloc] initWithDictionary:dict error:&err];
    if(err)
    {
        NSLog(@"[%@]:%@", NSStringFromClass(self), err);
    }
    return  data;
}


+ (instancetype)dataWithString:(NSString *)string
{
    JSONModelError *err;
    id data = [[self alloc] initWithString:string error:&err];
    if(err)
    {
        NSLog(@"[%@]:%@", NSStringFromClass(self), err);
    }
    return  data;
}



+ (NSString *)idGenerotor
{
    NSDate *date = [NSDate date];
    NSString *ID = [NSString stringWithFormat:@"%lld%lld",  (long long)(date.timeIntervalSince1970 * 1000), (long long)(arc4random() % 1000)];
    return ID;
}


//@"f":@"float", @"i":@"int", @"d":@"double", @"l":@"long", @"c":@"BOOL", @"s":@"short", @"q":@"long", @"I":@"NSInteger", @"Q":@"NSUInteger", @"B":@"BOOL", @"@?":@"Block"
- (instancetype)initWithResultSet:(FMResultSet *)rs
{
    self = [super init];
    if (self)
    {
        HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
        if (!dbModelMetadate) {
            dbModelMetadate = [[HQModelMetadate alloc] initWithClass:[self class]];
            [[HQDatabaseManager sharedInstance] setMetadate:dbModelMetadate forClass:[self class]];
        }
        id value = nil;
        for (HQModelClassProperty *dbProperty in dbModelMetadate.propertys)
        {
            if([dbProperty.type isEqualToString:@"NSDate"])
            {
                value = [rs dateForColumn:dbProperty.name];
            }
            else if([dbProperty.type isEqualToString:@"NSArray"] ||
                    [dbProperty.type isEqualToString:@"NSMutableArray"] ||
                    [dbProperty.type isEqualToString:@"NSDictionary"] ||
                    [dbProperty.type isEqualToString:@"NSMutableDictionary"])
            {
                
                value = [rs objectForColumnName:dbProperty.name];
                if (![value isKindOfClass:[NSNull class]]) {
                    value = [value toJSONObject];
                }
            }
            else if([dbProperty.type isEqualToString:@"NSData"])
            {
                value = [rs dataForColumn:dbProperty.name];
            }
            else if([NSClassFromString(dbProperty.type) isSubclassOfClass:[JSONModel class]])
            {
                NSString *json = [rs objectForColumnName:dbProperty.name];
                if(![json isKindOfClass:[NSNull class]])
                {
                    value = [[NSClassFromString(dbProperty.type) alloc] initWithString:json error:NULL];
                }
                else
                {
                    value = json;
                }
            }
            else if(([dbProperty.type isEqualToString:@"f"]) || ([dbProperty.type isEqualToString:@"d"]))
            {
                value = @([rs doubleForColumn:dbProperty.name]);
            }
            else if([dbProperty.type isEqualToString:@"c"] || [dbProperty.type isEqualToString:@"B"])
            {
                value = @([rs boolForColumn:dbProperty.name]);
            }
            else if([dbProperty.type isEqualToString:@"i"] || [dbProperty.type isEqualToString:@"I"])
            {
                value = @([rs intForColumn:dbProperty.name]);
            }
            else if ([dbProperty.type isEqualToString:@"l"])
            {
                value = @([rs longForColumn:dbProperty.name]);
            }
            else if ([dbProperty.type isEqualToString:@"q"])
            {
                value = @([rs longLongIntForColumn:dbProperty.name]);
            }
            else if ([dbProperty.type isEqualToString:@"Q"])
            {
                value = @([rs unsignedLongLongIntForColumn:dbProperty.name]);
            }
            else
            {
                value = [rs objectForColumnName:dbProperty.name];
            }
            
            if(![value isKindOfClass:[NSNull class]])
            {
                [self setValue:value forKey:dbProperty.name];
            }
            
        }
    }
    return self;
}

- (instancetype)initWithResultSet1:(FMResultSet *)rs
{
    self = [super init];
    if (self)
    {
        Class cla = [self class];
        for (int i = 0; i < rs.columnCount; i++)
        {
            NSString *columnName = [rs columnNameForIndex:i];
            objc_property_t objProperty = class_getProperty(cla, columnName.UTF8String);
            [self setProperty:self value:rs propertyName:columnName property:objProperty columnIdx:i];
        }
    }
    return self;
}

- (void)setProperty:(id)model value:(FMResultSet *)rs propertyName:(NSString *)propertyName property:(objc_property_t)property columnIdx:(int)columnIdx
{
    //    @"f":@"float",
    //    @"i":@"int",
    //    @"d":@"double",
    //    @"l":@"long",
    //    @"c":@"BOOL",
    //    @"s":@"short",
    //    @"q":@"long",
    //    @"I":@"NSInteger",
    //    @"Q":@"NSUInteger",
    //    @"B":@"BOOL",
    
    char *ss = property_getAttributes(property);
    NSString *firstType = [NSString stringWithUTF8String:property_getAttributes(property)];
    
//    NSLog(@"firstType %@ xx %@",firstType,@(ss[0] + ss[1]));
    
    if ([firstType hasPrefix:@"Tf"]) {
        NSNumber *number = [rs objectForColumnIndex:columnIdx];
        [model setValue:@(number.floatValue) forKey:propertyName];
        
    } else if([firstType hasPrefix:@"Ti"]){
        NSNumber *number = [rs objectForColumnIndex:columnIdx];
        [model setValue:@(number.intValue) forKey:propertyName];
        
    } else if([firstType hasPrefix:@"Td"]){
        [model setValue:[rs objectForColumnIndex:columnIdx] forKey:propertyName];
        
    } else if([firstType hasPrefix:@"Tl"] || [firstType hasPrefix:@"Tq"]){
        [model setValue:[rs objectForColumnIndex:columnIdx] forKey:propertyName];
        
    } else if([firstType hasPrefix:@"Tc"] || [firstType hasPrefix:@"TB"]){
        NSNumber *number = [rs objectForColumnIndex:columnIdx];
        [model setValue:@(number.boolValue) forKey:propertyName];
        
    } else if([firstType hasPrefix:@"Ts"]){
        NSNumber *number = [rs objectForColumnIndex:columnIdx];
        [model setValue:@(number.shortValue) forKey:propertyName];
        
    } else if([firstType hasPrefix:@"TI"]){
        NSNumber *number = [rs objectForColumnIndex:columnIdx];
        [model setValue:@(number.integerValue) forKey:propertyName];
        
    } else if([firstType hasPrefix:@"TQ"]){
        NSNumber *number = [rs objectForColumnIndex:columnIdx];
        [model setValue:@(number.unsignedIntegerValue) forKey:propertyName];
        
    } else if([firstType hasPrefix:@"T@\"NSData"]){
        NSData *value = [rs dataForColumn:propertyName];
        [model setValue:value forKey:propertyName];
        
    } else if([firstType hasPrefix:@"T@\"NSDate"]){
        NSDate *value = [rs dateForColumn:propertyName];
        [model setValue:value forKey:propertyName];
        
    } else if([firstType hasPrefix:@"T@\"NSString"]){
        NSString *value = [rs stringForColumnIndex:columnIdx];
        [model setValue:value forKey:propertyName];
        
    } else {
        [model setValue:[rs objectForColumnName:propertyName] forKey:propertyName];
    }
}

//这里目前只做了简单处理,够用
- (NSDictionary *)toModleDictionary
{
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    NSMutableDictionary* tempDictionary = [NSMutableDictionary dictionaryWithCapacity:dbModelMetadate.propertys.count];
    id value;
    for (HQModelClassProperty *dbModel in dbModelMetadate.propertys)
    {
        if([[self class] propertyIsAutoPrimary:dbModel.name])
        {
            continue;
        }
        value = [self valueForKey:dbModel.name];
        if(isNull(value))
        {
            [tempDictionary setObject:[NSNull null] forKey:dbModel.name];
        }
        else if([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]])
        {
            [tempDictionary setObject:[value toJSON] forKey:dbModel.name];
        }
        else if([value isKindOfClass:[JSONModel class]])
        {
            [tempDictionary setObject:[value toJSONString] forKey:dbModel.name];
        }
        else
        {
            [tempDictionary setObject:value forKey:dbModel.name];
        }
    }
    return tempDictionary;
}

+ (NSString *)create
{
    return [[HQDatabaseManager sharedInstance] dbModelMetadate:self].createSQL;
}

+ (NSString *)insert
{
    return [[HQDatabaseManager sharedInstance] dbModelMetadate:self].insertSQL;
}

- (BOOL)insert
{
    Class cla = [self class];
    FMDatabaseQueue * queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:dbModelMetadate.insertSQL withParameterDictionary:[self toModleDictionary]];
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    
    return success;
}

+ (BOOL)insertAll:(NSArray *)dataSource
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:cla];
    __block BOOL success = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (id obj in dataSource)
        {
            success = [db executeUpdate:dbModelMetadate.insertSQL withParameterDictionary:[obj toModleDictionary]];
        }
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

- (BOOL)delete
{
    Class cla = [self class];
    FMDatabaseQueue * queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
//    id keyValue = objc_msgSend(self,NSSelectorFromString(dbModelMetadate.primaryKey));
    
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:dbModelMetadate.delectSQL withParameterDictionary:[self toModleDictionary]];
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

+ (BOOL)deleteAll
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ ",NSStringFromClass(cla)]];
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

+ (BOOL)deleteArray:(NSArray *)datas
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    __block BOOL success = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (id obj in datas)
        {
            success = [db executeUpdate:dbModelMetadate.delectSQL withParameterDictionary:[obj toModleDictionary]];
        }
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

+ (BOOL)deleteByProperty:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",NSStringFromClass(cla),propertyName],propertyValue];
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

+ (BOOL)deleteByPropertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        NSMutableString *where = [NSMutableString string];
        NSArray *allKeys = [propertyMaps allKeys];
        for (int i = 0; i< allKeys.count; i++)
        {
            NSString *key = allKeys[i];
            if( i == allKeys.count -1 )
            {
                [where appendFormat:@" %@ = :%@",key,key];
            }
            else
            {
                [where appendFormat:@" %@ = :%@ AND",key,key];
            }
        }
        if(where.length)
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",NSStringFromClass(cla),where] withParameterDictionary:propertyMaps];
        }
        else
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",NSStringFromClass(cla)]];
        }
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

+ (BOOL)deleteByWHERE:(NSString *)where propertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",NSStringFromClass(cla),where] withParameterDictionary:propertyMaps];
    }];
#ifdef DEBUG
    if(success)
    {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

+ (BOOL)update:(NSString *)SQL
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:SQL];
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

+ (BOOL)updateBySQL:(NSString *)SQL propertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:SQL withParameterDictionary:propertyMaps];
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

//- (BOOL)updateByProperty:(NSString *)propertyName propertyValue:(id)propertyValue
//{
//    Class cla = [self class];
//    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
//    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
//    __block BOOL success = YES;
//    id keyValue = objc_msgSend(self,NSSelectorFromString(dbModelMetadate.primaryKey));
//    [queue inDatabase:^(FMDatabase *db) {
//        success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?",NSStringFromClass(cla),propertyName,dbModelMetadate.primaryKey],propertyValue,keyValue];
//    }];
//#ifdef DEBUG
//    if(success)
//        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
//    else
//        NSLog(@"%@  操作失败", NSStringFromClass(cla));
//#endif
//    return success;
//}



+ (BOOL)updateByProperty:(NSString *)propertyName propertyValue:(id)propertyValue keyValue:(id)keyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        if(keyValue)
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?",NSStringFromClass(cla),propertyName,dbModelMetadate.primaryKey],propertyValue,keyValue];
        }
        else
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? ",NSStringFromClass(cla),propertyName],propertyValue];
        }
        
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

+ (BOOL)updateByWHERE:(NSString *)sql propertyName:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@",NSStringFromClass(cla),propertyName,sql],propertyValue];
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

+ (BOOL)updateBySetMaps:(NSDictionary *)setMaps whereMaps:(NSDictionary *)whereMaps
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        
        NSMutableString *where = [NSMutableString string];
        NSMutableString *set = [NSMutableString string];
        NSArray *allKeys = [setMaps allKeys];
        
        for ( int i=0; i<allKeys.count; i++)
        {
            NSString *key = allKeys[i];
            if(i == allKeys.count -1)
            {
                [set appendFormat:@" %@ = :%@",key,key];
            }
            else
            {
                [set appendFormat:@" %@ = :%@,",key,key];
            }
        }
        
        allKeys = [whereMaps allKeys];
        
        for ( int i=0; i<allKeys.count; i++)
        {
            NSString *key = allKeys[i];
            if(i == allKeys.count-1 )
            {
                [where appendFormat:@" %@ = :%@",key,key];
            }
            else
            {
                [where appendFormat:@" %@ = :%@ AND",key,key];
            }
        }
        
        if(set.length == 0)
        {
            success = NO;
            return;
        }
        
        if(where.length)
        {
            NSMutableDictionary *maps = [NSMutableDictionary dictionaryWithDictionary:setMaps];
            [maps addEntriesFromDictionary:whereMaps];
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",NSStringFromClass(cla),set,where] withParameterDictionary:maps];
        }
        else
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@",NSStringFromClass(cla),set]];
        }
        
    }];
#ifdef DEBUG
    if(success)
        {}//HQLogInfo(@"%@ 操作成功", NSStringFromClass(cla));
    else
        NSLog(@"%@  操作失败", NSStringFromClass(cla));
#endif
    return success;
}

+ (NSArray *)all
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue * queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
//    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass(cla)]];
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
//            id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
//            if(keyValue)
            {
                [array addObject:obj];
            }
        }
        [rs close];
    }];
    return array;
}

//+ (NSArray *)allTest
//{
//    Class cla = [self class];
//    NSMutableArray *array = [NSMutableArray array];
//    FMDatabaseQueue * queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
//    //    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass(cla)]];
//        while ([rs next])
//        {
//            
//            id obj = [cla hq_dataWithResultSet:rs];
//            //            id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
//            //            if(keyValue)
//            {
//                [array addObject:obj];
//            }
//        }
//        [rs close];
//    }];
//    return array;
//}

//- (NSArray *)allTest1
//{
//    Class cla = [self class];
//    NSMutableArray *array = [NSMutableArray array];
//    FMDatabaseQueue * queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
//    //    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass(cla)]];
//        while ([rs next])
//        {
//            
//            id obj = [cla hq_dataWithResultSet:rs];
//            //            id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
//            //            if(keyValue)
//            {
//                [array addObject:obj];
//            }
//        }
//        [rs close];
//    }];
//    return array;
//}

+ (NSArray *)selectByProperty:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
//    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",NSStringFromClass(cla),propertyName],propertyValue];
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet1:rs];
//            id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
//            if(keyValue)
            {
                [array addObject:obj];
            }
        }
        [rs close];
    }];
    return array;
}

+ (NSArray *)selectByPropertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
//    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db) {
        NSMutableString *where = [NSMutableString string];
        NSArray *allKeys = [propertyMaps allKeys];
        for (int i = 0; i< allKeys.count; i++)
        {
            NSString *key = allKeys[i];
            if( i == allKeys.count -1 )
            {
                [where appendFormat:@" %@ = :%@",key,key];
            }
            else
            {
                [where appendFormat:@" %@ = :%@ AND",key,key];
            }
        }

        FMResultSet *rs;
        if(where.length)
        {
            rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",NSStringFromClass(cla),where] withParameterDictionary:propertyMaps];
        }
        else
        {
            rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass(cla)]];
        }
        
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
//            id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
//            if(keyValue)
            {
                [array addObject:obj];
            }
        }
        [rs close];
    }];
    return array;
}

+ (NSArray *)selectBySQL:(NSString *)sql
{
    return [self selectBySQL:sql propertyMaps:nil];
}

+ (NSArray *)selectBySQL:(NSString *)sql propertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
//    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db)
    {
        FMResultSet *rs = [db executeQuery:sql withParameterDictionary:propertyMaps];
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
//            id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
//            if(keyValue)
            {
                [array addObject:obj];
            }
            
        }
        [rs close];
    }];
    return array;
}


+ (NSArray *)selectByWHERE:(NSString *)sql propertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
//    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",NSStringFromClass(cla),sql] withParameterDictionary:propertyMaps];
         while ([rs next])
         {
             id obj = [[cla alloc] initWithResultSet:rs];
//             id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
//             if(keyValue)
             {
                 [array addObject:obj];
             }
         }
         [rs close];
     }];
    return array;
}


@end
