//
//  NSString+util.m
//  seafishing2
//
//  Created by zhaoyk10 on 13-4-26.
//  Copyright (c) 2013年 Szfusion. All rights reserved.
//

#import "NSString+util.h"


static uint64_t encoding_value(NSString *s, NSStringEncoding enc) {
    NSData *data;
    uint64_t value = 0;
    
    if (s.length == 0) {
        return 0;
    } else if (s.length > 1) {
        s = [s substringWithRange:NSMakeRange(0, 1)];
    }
    data = [s dataUsingEncoding:enc];
    if (data.length == 1) {
        char c;
        [data getBytes:&c length:1];
        value = c & 0xff;
    } else if (data.length == 2) {
        char c[2];
        [data getBytes:&c length:2];
        value = ((c[0]&0xff) << 8) | (c[1]&0xff);
    } else if (data.length == 3) {
        char c[3];
        [data getBytes:&c length:3];
        value = ((c[0]&0xff) << 16) | ((c[1]&0xff) << 8) | (c[2]&0xff);
    } else if (data.length == 4) {
        char c[4];
        [data getBytes:&c length:4];
        value = ((c[0]&0xff) << 24) | ((c[1]&0xff) << 16) | ((c[2]&0xff) << 8) | (c[3]&0xff);
    }
    return value;
}

uint64_t shiftjis_value(NSString *s) {
    return encoding_value(s, NSShiftJISStringEncoding);
}

uint64_t gbk_value(NSString *s) {
    return encoding_value(s, CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000));
}

uint64_t unicode_value(NSString *s) {
    return encoding_value(s, CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8));
}

@implementation NSString (util)

+ (NSString *)uniqueString {
    return [[NSProcessInfo processInfo] globallyUniqueString];
}

+ (NSString *)uniqueStringWithoutDash {
    NSString *str = [self uniqueString];
    return [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (BOOL)contains:(NSString *)str {
    return [self rangeOfString:str].location != NSNotFound;
}

- (NSArray *)split:(NSString *)str {
    return [self componentsSeparatedByString:str];
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)ltrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range = [self rangeOfCharacterFromSet:[set invertedSet]];
    if (range.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:range.location];
}

- (NSString *)rtrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range = [self rangeOfCharacterFromSet:[set invertedSet]
                                                               options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:range.location + 1];
}

- (BOOL)isEqualsIgnorecase:(NSString *)str {
    return [self caseInsensitiveCompare:str] == NSOrderedSame;
}

- (int)indexOf:(NSString *)str {
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound) {
        return -1;
    } else {
        return range.location;
    }
}

- (BOOL)startWith:(NSString *)str {
    return [self indexOf:str] == 0;
}

- (BOOL)endWith:(NSString *)str {
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound) {
        return NO;
    } else if (range.location + range.length == self.length) {
        return YES;
    } else {
        return NO;
    }
}

- (id)toJSONObject {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"to json error: %@ for string: %@", error, self);
        return nil;
    }
    return obj;
}


- (BOOL)match:(NSString *)regexStr {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    if (error != nil) {
        NSLog(@"NSRegularExpression create error: %@", error);
        return NO;
    }
    NSUInteger n = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return n != 0;
}

// ios 字符串判断非空
//排除空格
+ (BOOL) isBlankString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]])
    {
        return YES;
    }
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


// 不排除空格
+ (BOOL)isNullString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}


+ (BOOL)isEmail:(NSString *)string {
    if ([self isBlankString:string]) {
        return NO;
    }
    NSString *re = @"^[A-Za-z0-9._%+-]{1,64}@[A-Za-z0-9.-]{1,64}\\.(([A-Za-z]{2,6})|([A-Za-z]{2,3}\\.[A-Za-z]{2}))$";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:re options:NSRegularExpressionCaseInsensitive error:&error];
    if (error != nil) {
        NSLog(@"NSRegularExpression create error: %@", error);
        return NO;
    }
    NSUInteger n = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    return n != 0;
}

+ (BOOL)isLatitude:(NSString *)string
{
    NSString *re = @"^(-?((90)|((([0-8]\\d)|(\\d{1}))(\\.\\d+)?)))$";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:re options:NSRegularExpressionCaseInsensitive error:&error];
    if (error != nil) {
        NSLog(@"NSRegularExpression create error: %@", error);
    }
    NSUInteger n = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    return n;
}

+ (BOOL)isLongitude:(NSString *)string
{
    NSString *re = @"^(-?((180)|(((1[0-7]\\d)|(\\d{1,2}))(\\.\\d+)?)))$";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:re options:NSRegularExpressionCaseInsensitive error:&error];
    if (error != nil) {
        NSLog(@"NSRegularExpression create error: %@", error);
    }
    NSUInteger n = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    return n;
}


+ (NSUInteger) lenghtWithString:(NSString *)string
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return len + numMatch;
}

- (NSUInteger)unicodeLength {
    NSUInteger len = 0, l = self.length;
    for (int i = 0; i < l; ++i) {
        unichar c = [self characterAtIndex:i];
        if (c > 0xD800) {
            i++;
        }
        len++;
    }
    return len;
}

- (NSString *)unicodeSubstringToIndex:(NSUInteger)index {
    unichar *cs = malloc(index * 2);
    NSUInteger len = 0, clen = self.length;
    
    int i = 0;
    for (; i < clen; ++i) {
        if (len >= index) {
            break;
        }
        unichar c = [self characterAtIndex:i];
        if (c < 0xD800) {
            *(cs + i) = c;
        } else if (i + 1 < clen) {
            *(cs + i) = c;
            i++;
            *(cs + i) = [self characterAtIndex:i];
        }
        len++;
    }
    NSString *s = [[NSString alloc] initWithCharacters:(const unichar*)cs length:i];
    free(cs);
    return s;
}

+ (BOOL) Astring:(NSString *)Astr hasBstring:(NSString *)Bstr
{
    if ([NSString isBlankString:Astr] || [NSString isBlankString:Bstr]) {
        return NO;
    }
    NSRange range=[Astr rangeOfString:Bstr];
    if(range.location!= NSNotFound){
        return YES;
    }else{
        return NO;
    }
}


// iOS 获取字符串中的单个字符
- (NSArray *)words
{
#if ! __has_feature(objc_arc)
    NSMutableArray *words = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray *words = [[NSMutableArray alloc] init];
#endif
    const char *str = [self cStringUsingEncoding:NSUTF8StringEncoding];
    char *word;
    for (int i = 0; i < strlen(str);) {
        int len = 0;
        if (str[i] >= 0xFFFFFFFC) {
            len = 6;
        } else if (str[i] >= 0xFFFFFFF8) {
            len = 5;
        } else if (str[i] >= 0xFFFFFFF0) {
            len = 4;
        } else if (str[i] >= 0xFFFFFFE0) {
            len = 3;
        } else if (str[i] >= 0xFFFFFFC0) {
            len = 2;
        } else if (str[i] >= 0x00) {
            len = 1;
        }
        word = malloc(sizeof(char) * (len + 1));
        for (int j = 0; j < len; j++) {
            word[j] = str[j + i];
        }
        word[len] = '\0';
        i = i + len;
        
        NSString *oneWord = [NSString stringWithCString:word encoding:NSUTF8StringEncoding];
        free(word);
        [words addObject:oneWord];
    }
    return words;
}
// 获取长度
+  (NSUInteger)getStringLength:(NSString*)strtemp {
    
    NSUInteger strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p != '\0') {
            
            strlength++;
        }
        p++;
    }
    return strlength;
    
}

- (NSUInteger)cLength
{
    return [NSString getStringLength:self];
}

// 去掉多个换行 或者多个空格  a表示是换行还是空格
// 比如： a = @"\n"    a = " "
+ (NSString *)replaceEntrerString:(NSString *)str withString:(NSString *)a;
{
    NSString *result;
    if (str == nil) {
        return nil;
    }
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:[NSString stringWithFormat:@"%@{1,}",a]
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    result = [regular stringByReplacingMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length) withTemplate:a];
    return result;
}

+ (NSString *)replaceSpace:(NSString *)str
{
    NSString *content = str;
    content = [content trim];
    content = [NSString replaceEntrerString:content withString:@"\n"];
    content = [NSString replaceEntrerString:content withString:@" "];
    return content;
}




// 获取设备名字 对照表 http://blog.csdn.net/templar1000/article/details/16985455
//+ (NSString *)deviceString:(NSString *)deviceString
//{
//    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
//    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
//    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
//    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
//    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
//    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
//    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
//    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
//    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
//    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
//    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
//    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
//    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2";
//    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
//    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2";
//    if ([deviceString isEqualToString:@"iPad3,1"])      return @"3rd Generation iPad";
//    if ([deviceString isEqualToString:@"iPad3,4"])      return @"4th Generation iPad";
//    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini";
//    if ([deviceString isEqualToString:@"iPad4,1"])      return @"5th Generation iPad (iPad Air)";
//    if ([deviceString isEqualToString:@"iPad4,2"])      return @"5th Generation iPad (iPad Air)";
//    if ([deviceString isEqualToString:@"iPad4,4"])      return @"on 2nd Generation iPad Mini";
//    if ([deviceString isEqualToString:@"iPad4,5"])      return @"on 2nd Generation iPad Mini";
//    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
//    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
//    
//    NSLog(@"NOTE: Unknown device type: %@", deviceString);
//    return deviceString;
//}

+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

/**
 *  用户名长度检测
 *
 *  @param src       输入
 *  @param maxLength Ascii字符个数
 *
 *  @return 截取后字符串
 */
+ (NSString *)substringWithAsciiLen:(NSString *)src maxLength:(int)maxLength
{
    NSMutableString *dst = [NSMutableString string];
    int len = 0;
    for (int i = 0; i < src.length; i++)
    {
        NSString *tmp = [src substringWithRange:NSMakeRange(i, 1)];
        len += [NSString getStringLength:tmp];
        if(len <= maxLength)
        {
            [dst appendString:tmp];
        }
        else
        {
            break;
        }
    }
    return dst;
}


@end
