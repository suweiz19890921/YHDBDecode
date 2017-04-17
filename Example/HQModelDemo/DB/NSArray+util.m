//
//  NSArray+util.m
//  seafishing2
//
//  Created by zhaoyk10 on 13-5-23.
//  Copyright (c) 2013年 Szfusion. All rights reserved.
//

#import "NSArray+util.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface SortedObj : NSObject
@property (nonatomic) uint64_t value;
@property (nonatomic, strong) id obj;
@end
@implementation SortedObj
@end

@implementation NSArray (util)

- (NSString *)toJSON {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//#pragma mark - 名称排序
//- (NSArray *)sortWithNameSel:(SEL)sel valuefunc:(uint64_t (*)(NSString*))func {
//    NSMutableArray *_array = [NSMutableArray array];
//    for (id obj in self) {
//        NSString *value = ((NSString* (*) (id, SEL))objc_msgSend)(obj, sel);
//        uint64_t v = func(value);
//        SortedObj *sobj = [[SortedObj alloc] init];
//        sobj.value = v;
//        sobj.obj = obj;
//        [_array addObject:sobj];
//    }
//    NSArray *sortedArray = [_array sortedArrayWithOptions:NSSortStable
//                                          usingComparator:^(SortedObj *obj1, SortedObj *obj2) {
//                                              if (obj1.value < obj2.value) {
//                                                  return NSOrderedAscending;
//                                              } else if (obj1.value > obj2.value) {
//                                                  return NSOrderedDescending;
//                                              } else {
//                                                  return NSOrderedSame;
//                                              }
//                                          }];
//    NSMutableArray *result = [NSMutableArray array];
//    for (SortedObj *sobj in sortedArray) {
//        [result addObject:sobj.obj];
//    }
//    return result;
//}

- (NSArray *)groupByProperty:(NSString *)property
{
    NSString *keyPath = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@",property];
    NSArray *propertyValue = [self valueForKeyPath:keyPath];
    
    NSMutableArray *groupArray = [NSMutableArray array];
    [propertyValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[property stringByAppendingString:@"== %@"],obj];
        NSMutableArray *filters = [[self filteredArrayUsingPredicate:predicate] mutableCopy];
        if(filters.count > 0)[groupArray addObject:filters];
        
    }];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[property stringByAppendingString:@"== nil"],property];
    NSArray *nullArray = [self filteredArrayUsingPredicate:predicate];
    if(nullArray.count > 0)[groupArray addObject:nullArray];
    return groupArray;
}

@end

@implementation NSMutableArray (util)

- (void)unshiftObject:(id)obj {
    [self insertObject:obj atIndex:0];
}

- (void)unshiftObjects:(NSArray *)array {
    for (int i = array.count - 1; i >= 0; --i) {
        id obj = array[i];
        [self insertObject:obj atIndex:0];
    }
}

@end
