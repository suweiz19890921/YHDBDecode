//
//  FishBaseModel.m
//  Catches
//
//  Created by 杨杰 on 16/3/4.
//  Copyright © 2016年 solot. All rights reserved.
//

#import "FishBaseModel.h"

@implementation FishBaseModel
//+ (long long)lastTime
//{
//    Class cla = [self class];
//    NSArray * ary = [self selectBySQL:[NSString stringWithFormat:@"select max(lastTime),* FROM %@",cla]];
//    id ssss = [ary lastObject];
//    if ([ssss respondsToSelector:@selector(lastTime)]) {
//        return  [[ary lastObject] lastTime];
//    }
//    return 0;
//}

////检测是否含有该属性或者成员
//+ (BOOL) getVariableWithClass:(Class) myClass varName:(NSString *)name{
//    unsigned int outCount, i;
//    Ivar *ivars = class_copyIvarList(myClass, &outCount);
//    for (i = 0; i < outCount; i++) {
//        Ivar property = ivars[i];
//        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
//        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
//        if ([keyName isEqualToString:name]) {
//            return YES;
//        }
//    }
//    return NO;
//}
@end
