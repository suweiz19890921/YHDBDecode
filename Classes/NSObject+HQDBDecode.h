//
//  NSObject+HQDBDecode.h
//  HQModelDemo
//
//  Created by 刘欢庆 on 2017/4/11.
//  Copyright © 2017年 刘欢庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface NSObject (HQDBDecode)
+ (nullable instancetype)hq_dataWithResultSet:(nullable FMResultSet *)rs;


@end

@protocol HQDBDecode <NSObject>
@optional
+ (nullable NSArray<NSString *> *)hq_propertyIsIgnored;
@end
