//
//  HQModelClassProperty.m
//  CameraRuler
//
//  Created by LiuHuanQing on 15/4/3.
//  Copyright (c) 2015年 HQ_L. All rights reserved.
//

#import "HQModelClassProperty.h"

@implementation HQModelClassProperty

+ (HQModelClassProperty *)property:(objc_property_t)property
{
    HQModelClassProperty *dbModel = [[HQModelClassProperty alloc] init];
    NSScanner* scanner            = nil;
    NSString *propertyType        = nil;
    
    const char *name         = property_getName(property);
    dbModel.name = @(name);
    
    const char *attrs = property_getAttributes(property);
    NSString* propertyAttributes = @(attrs);
    NSLog(@"%@",propertyAttributes);
    scanner = [NSScanner scannerWithString: propertyAttributes];
    [scanner scanUpToString:@"T" intoString: nil];
    [scanner scanString:@"T" intoString:nil];
    
    if ([scanner scanString:@"@\"" intoString: &propertyType])
    {//对象
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                intoString:&propertyType];
        dbModel.type = propertyType;
        
        //解析协议
        dbModel.isPrimaryKey = NO;
        dbModel.isUnique = NO;
        while ([scanner scanString:@"<" intoString:NULL]) {
            NSString* protocolName = nil;
            [scanner scanUpToString:@">" intoString: &protocolName];
            if ([protocolName isEqualToString:@"PrimaryKey"]) {
                dbModel.isPrimaryKey = YES;
            }
            else if ([protocolName isEqualToString:@"Unique"])
            {
                dbModel.isUnique = YES;
            }
            else if([protocolName isEqualToString:@"Ignore"])
            {
                return nil;
            }
            [scanner scanString:@">" intoString:NULL];
        }
        
    }
    else if ([scanner scanString:@"{" intoString: &propertyType])
    {//结构体
        [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet]
                            intoString:&propertyType];
        
        dbModel.type = propertyType;
        
    }
    else
    {//基本类型
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@","]
                                intoString:&propertyType];
        dbModel.type = propertyType;
    }
    
    return dbModel;
}

@end
