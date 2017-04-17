//
//  TestModel.m
//  HQModelDemo
//
//  Created by 刘欢庆 on 2017/4/17.
//  Copyright © 2017年 刘欢庆. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel
+ (nonnull NSString *)hq_dbName
{
    return @"localData.db";
}

+ (nullable NSArray<NSString *> *)hq_propertyPrimarykeyList
{
    return @[@"userno"];
}


+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"subdatas" : @"TestSub1Model"};
}
@end
