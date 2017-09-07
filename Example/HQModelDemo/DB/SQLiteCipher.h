//
//  SQLiteCipher.h
//  Catches
//
//  Created by 刘欢庆 on 2017/2/14.
//  Copyright © 2017年 solot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteCipher : NSObject
/**
 *  对数据库加密
 *
 *  @param path path description
 *
 *  @return return value description
 */
+ (BOOL)encryptDatabase:(NSString *)path;

/**
 *  对数据库解密
 *
 *  @param path path description
 *
 *  @return return value description
 */
+ (BOOL)unEncryptDatabase:(NSString *)path;

/**
 *  修改数据库秘钥
 *
 *  @param dbPath    dbPath description
 *  @param originKey originKey description
 *  @param newKey    newKey description
 *
 *  @return return value description
 */
+ (BOOL)changeKey:(NSString *)dbPath originKey:(NSString *)originKey newKey:(NSString *)newKey;
@end
