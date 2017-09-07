//
//  YHBait.m
//  Catches
//
//  Created by 刘欢庆 on 2017/7/27.
//  Copyright © 2017年 solot. All rights reserved.
//

#import "YHBait.h"
@interface YHBait()
{
    NSString *_nameByUseLanguage;
}
@end

@implementation YHBait
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"ID": @"id"};
}

+ (nullable NSArray<NSString *> *)hq_propertyPrimarykeyList;
{
    return @[@"ID"];
}

/** 所属库名称 该字段是生成数据库的必要字段*/
+ (nonnull NSString *)hq_dbName
{
    return @"base.db";
}


- (NSString *)nameByUseLanguage
{
    if(!_nameByUseLanguage)
    {
        _nameByUseLanguage = [NSString stringWithFormat:@"%@", [_name objectForKey:[GlobalConfig dataBaseLanguageHasJa]]];
        if(!_nameByUseLanguage)_nameByUseLanguage = [NSString stringWithFormat:@"%@", [_name objectForKey:@"en"]];
    }
    return _nameByUseLanguage;
}
@end
