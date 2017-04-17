//
//  NSString+util.h
//  seafishing2
//
//  Created by zhaoyk10 on 13-4-26.
//  Copyright (c) 2013年 Szfusion. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回字符串s第一个字的gbk编码值
 */
extern uint64_t gbk_value(NSString *s);
extern uint64_t shiftjis_value(NSString *s);
extern uint64_t unicode_value(NSString *s);

@interface NSString (util)

+ (NSString *)uniqueString;
+ (NSString *)uniqueStringWithoutDash;

- (BOOL)contains:(NSString *)str;

- (NSArray *)split:(NSString *)str;

- (NSString *)trim;
- (NSString *)ltrim;
- (NSString *)rtrim;

- (BOOL)isEqualsIgnorecase:(NSString *)str;

- (int)indexOf:(NSString *)str;

- (BOOL)startWith:(NSString *)str;

- (BOOL)endWith:(NSString *)str;

- (id)toJSONObject;

- (BOOL)match:(NSString *)regexStr;
/*
 ECB/SFPKCS7Padding, utf8
 */
- (NSString *)encryptUseAesKey:(NSString *)key IV:(NSString *)iv;
- (NSString *)dencryptUseAesKey:(NSString *)key IV:(NSString *)iv;

+ (BOOL)isBlankString:(NSString *)string;


+ (BOOL)isNullString:(NSString *)string;
+ (BOOL)isEmail:(NSString *)string;

+ (NSUInteger) lenghtWithString:(NSString *)string;

- (NSUInteger)unicodeLength;
- (NSString *)unicodeSubstringToIndex:(NSUInteger)index;

+ (NSString *)brithdayToAge:(NSString *)birthday;
+ (BOOL) Astring:(NSString *)Astr hasBstring:(NSString *)Bstr;

// iOS 获取字符串中的单个字符
- (NSArray *)words;
+  (NSUInteger)getStringLength:(NSString*)strtemp;

//字符长度(char长度)
- (NSUInteger)cLength;

+ (NSString *)replaceEntrerString:(NSString *)str withString:(NSString *)a;

//// 获取设备名字
//+ (NSString *)deviceString:(NSString *)deviceString;

// 判断是整数
+ (BOOL)isPureInt:(NSString *)string;;
// 判断是浮点数
+ (BOOL)isPureFloat:(NSString *)string;

/**
 *  去掉空格与换行
 *
 *  @param str 输入
 *
 *  @return 输出
 */
+ (NSString *)replaceSpace:(NSString *)str;

+ (NSString *)substringWithAsciiLen:(NSString *)src maxLength:(int)maxLength;

//字符串的size
//- (CGSize)strSizeWithFont:(UIFont *)font size:(CGSize)size;
//- (CGSize)strSizeWithFont:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
//- (CGSize)strSizeWithFont:(UIFont *)font size:(CGSize)size lineSpace:(CGFloat)lineSpace;


+ (BOOL)isLatitude:(NSString *)string;
+ (BOOL)isLongitude:(NSString *)string;

+ (NSString *)trim:(NSString *)string length:(NSInteger)length;

+ (NSString *)countryFlag:(NSString *)hasc;

@end
