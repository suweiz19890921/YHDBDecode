//
//  NSObject+HQDBDecode.m
//  HQModelDemo
//
//  Created by 刘欢庆 on 2017/4/11.
//  Copyright © 2017年 刘欢庆. All rights reserved.
//

#import "NSObject+HQDBDecode.h"
#import "objc/message.h"
#import "HQDBDecodeUtilities.h"
#import "NSObject+YYModel.h"
#define force_inline __inline__ __attribute__((always_inline))


static force_inline HQEncodingTypeNSType HQClassGetNSType(Class cls)
{
    if (!cls) return HQEncodingTypeNSUnknown;
    if ([cls isSubclassOfClass:[NSMutableString class]]) return HQEncodingTypeNSMutableString;
    if ([cls isSubclassOfClass:[NSString class]]) return HQEncodingTypeNSString;
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) return HQEncodingTypeNSDecimalNumber;
    if ([cls isSubclassOfClass:[NSNumber class]]) return HQEncodingTypeNSNumber;
    if ([cls isSubclassOfClass:[NSValue class]]) return HQEncodingTypeNSValue;
    if ([cls isSubclassOfClass:[NSMutableData class]]) return HQEncodingTypeNSMutableData;
    if ([cls isSubclassOfClass:[NSData class]]) return HQEncodingTypeNSData;
    if ([cls isSubclassOfClass:[NSDate class]]) return HQEncodingTypeNSDate;
    if ([cls isSubclassOfClass:[NSURL class]]) return HQEncodingTypeNSURL;
    if ([cls isSubclassOfClass:[NSMutableArray class]]) return HQEncodingTypeNSMutableArray;
    if ([cls isSubclassOfClass:[NSArray class]]) return HQEncodingTypeNSArray;
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return HQEncodingTypeNSMutableDictionary;
    if ([cls isSubclassOfClass:[NSDictionary class]]) return HQEncodingTypeNSDictionary;
    if ([cls isSubclassOfClass:[NSMutableSet class]]) return HQEncodingTypeNSMutableSet;
    if ([cls isSubclassOfClass:[NSSet class]]) return HQEncodingTypeNSSet;
    return HQEncodingTypeNSUnknown;
}



@interface _HQClassPropertyInfo : NSObject
{
    @package
    NSString *_name;
    HQEncodingType _type;
    HQEncodingTypeNSType _nsType;
    Class _cls;
    SEL _setter;
}
@end

@implementation _HQClassPropertyInfo
- (instancetype)initWithProperty:(objc_property_t)property
{
    self = [super init];
    if(self)
    {
        const char *name         = property_getName(property);
        if (name) {
            _name = [NSString stringWithUTF8String:name];
        }
        
        const char *attrs = property_getAttributes(property);
        _type = HQEncodingGetType(attrs);
        
        NSString *typeEncoding = @(attrs);
        NSString *clsName      = nil;
        if(_type == HQEncodingTypeObject)
        {
            NSScanner* scanner            = nil;
            scanner = [NSScanner scannerWithString: typeEncoding];
            [scanner scanUpToString:@"T" intoString: nil];
            [scanner scanString:@"T" intoString:nil];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                    intoString:&clsName];
            if (clsName.length) _cls = objc_getClass(clsName.UTF8String);
            _nsType = HQClassGetNSType(_cls);

        }
        
        if (!_setter) {
            _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]]);
        }
    }
    return self;
}
@end


@interface _HQDBDecodeMeta : NSObject
{
    @package
    NSDictionary *_mapper;
    NSArray *_allPropertyInfos;
    NSString *_createSQL;
    NSString *_insertSQL;
    NSString *_delectSQL;
}
@end

@implementation _HQDBDecodeMeta
+ (instancetype)metaWithClass:(Class)cls
{
    _HQDBDecodeMeta *meta = [[_HQDBDecodeMeta alloc] initWithClass:cls];
    return meta;
}


- (instancetype)initWithClass:(Class)cls
{
    if(!cls)return nil;
    self = [super init];
    if(self)
    {
        NSSet *ignoredList = nil;
        if ([cls respondsToSelector:@selector(hq_propertyIsIgnored)])
        {
            NSArray *properties = [(id<HQDBDecode>)cls hq_propertyIsIgnored];
            if(properties)
            {
                ignoredList = [NSSet setWithArray:properties];
            }
        }
            
        unsigned int count             = 0;
        NSString *clsName            = NSStringFromClass(cls);
        NSMutableArray *propertyInfo   = [NSMutableArray array];
        NSMutableDictionary *mapper    = [NSMutableDictionary new];

        do {
            objc_property_t *properties    = class_copyPropertyList(cls, &count);
            
            for (int i = 0; i < count; i++)
            {

                objc_property_t property      = properties[i];
                _HQClassPropertyInfo *info = [[_HQClassPropertyInfo alloc] initWithProperty:property];
                
                if (ignoredList && [ignoredList containsObject:info->_name]) continue;
                if(info->_type == HQEncodingTypeUnknown || info->_type == HQEncodingTypeVoid) continue;
                if(info->_nsType == HQEncodingTypeNSUnknown) continue;

                mapper[info->_name] = info;
                [propertyInfo addObject:info];
                NSLog(@"%@",info->_name);
            }
            free(properties);
            cls = [cls superclass];
        } while (![NSStringFromClass(cls) isEqualToString:@"NSObject"]);
        
        _allPropertyInfos = propertyInfo;
        _mapper = mapper;
    }
    return self;
}

@end


static force_inline void ModelSetObjectToProperty(__unsafe_unretained id model,
                                                  __unsafe_unretained FMResultSet *rs,
                                                  __unsafe_unretained _HQClassPropertyInfo *info,
                                                  __unsafe_unretained NSString *columnName)
{
    switch (info->_nsType)
    {
        case HQEncodingTypeNSString:
        case HQEncodingTypeNSMutableString:
            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, info->_setter, [rs stringForColumn:columnName]);
            break;
        case HQEncodingTypeNSDate:
            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, info->_setter, [rs dateForColumn:columnName]);
            break;
        case HQEncodingTypeNSData:
        case HQEncodingTypeNSMutableData:
            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, info->_setter, [rs dataForColumn:columnName]);
            break;
        case HQEncodingTypeNSArray:
        case HQEncodingTypeNSMutableArray:
        case HQEncodingTypeNSDictionary:
        case HQEncodingTypeNSMutableDictionary:
        {
            NSString *value = [rs stringForColumn:columnName];
            if (value)
            {
                NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error;
                id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (!error)
                {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, info->_setter, obj);
                }
            }
        }
            break;
        default:
        {
            id value = [rs stringForColumn:columnName];
            if (value)
            {
                id obj = [info->_cls yy_modelWithJSON:value];
                if(obj)
                {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, info->_setter, obj);
                }
            }
        }
            break;
    }
}

@implementation NSObject (HQDBDecode)
+ (instancetype)hq_dataWithResultSet:(FMResultSet *)rs
{
    Class cls = [self class];
    
    _HQDBDecodeMeta *meta = [_HQDBDecodeMeta metaWithClass:cls];
    for (int i = 0; i < rs.columnCount; i++)
    {
        NSString *columnName = [rs columnNameForIndex:i];
        _HQClassPropertyInfo *info = meta->_mapper[columnName];
        switch (info->_type)
        {
            case HQEncodingTypeVoid:
                break;
            case HQEncodingTypeBool:
            {
                ((void (*)(id, SEL, bool))(void *) objc_msgSend)((id)self, info->_setter, [rs boolForColumn:columnName]);
            }
                break;
                
            case HQEncodingTypeInt8:
            {
                ((void (*)(id, SEL, int8_t))(void *) objc_msgSend)((id)self, info->_setter, (int8_t)[rs intForColumn:columnName]);
            }
                break;
            case HQEncodingTypeUInt8:
            {
                ((void (*)(id, SEL, uint8_t))(void *) objc_msgSend)((id)self, info->_setter, (uint8_t)[rs intForColumn:columnName]);
            }
                break;
            case HQEncodingTypeInt16:
            {
                ((void (*)(id, SEL, int16_t))(void *) objc_msgSend)((id)self, info->_setter, (int16_t)[rs intForColumn:columnName]);
            }
                break;
            case HQEncodingTypeUInt16:
            {
                ((void (*)(id, SEL, uint16_t))(void *) objc_msgSend)((id)self, info->_setter, (uint16_t)[rs intForColumn:columnName]);
            }
                break;
            case HQEncodingTypeInt32:
            {
                ((void (*)(id, SEL, int32_t))(void *) objc_msgSend)((id)self, info->_setter, (int32_t)[rs intForColumn:columnName]);
            }
            case HQEncodingTypeUInt32:
            {
                ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)((id)self, info->_setter, (uint32_t)[rs intForColumn:columnName]);
            }
                break;
            case HQEncodingTypeInt64:
            {
                ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)((id)self, info->_setter, (uint32_t)[rs longLongIntForColumn:columnName]);
            }
                break;
            case HQEncodingTypeUInt64:
            {
                ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)((id)self, info->_setter, (uint32_t)[rs unsignedLongLongIntForColumn:columnName]);
            }
                break;
            case HQEncodingTypeFloat:
            {
                float f = [rs doubleForColumn:columnName];
                if (isnan(f) || isinf(f)) f = 0;
                ((void (*)(id, SEL, float))(void *) objc_msgSend)((id)self, info->_setter, f);
            }
                break;
            case HQEncodingTypeDouble:
            {
                double d = [rs doubleForColumn:columnName];
                if (isnan(d) || isinf(d)) d = 0;
                ((void (*)(id, SEL, double))(void *) objc_msgSend)((id)self, info->_setter, d);
            }
                break;
            case HQEncodingTypeLongDouble:
            {
                long double d = [rs doubleForColumn:columnName];
                if (isnan(d) || isinf(d)) d = 0;
                ((void (*)(id, SEL, long double))(void *) objc_msgSend)((id)self, info->_setter, (long double)d);
            }
                break;
            case HQEncodingTypeObject:
            {
                ModelSetObjectToProperty(self,rs,info,columnName);
            }
                break;
            default:
                break;
        }
        
    }
    
    return nil;
}

@end































