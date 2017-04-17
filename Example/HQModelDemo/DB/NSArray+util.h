//
//  NSArray+util.h
//  seafishing2
//
//  Created by zhaoyk10 on 13-5-23.
//  Copyright (c) 2013年 Szfusion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (util)

- (NSString *)toJSON;

//- (NSArray *)sortWithNameSel:(SEL)sel valuefunc:(uint64_t (*)(NSString*))func;
- (NSArray *)groupByProperty:(NSString *)property;
@end

@interface NSMutableArray (util)

/**
 a = @[ "b", "c", "d" ]
 [a unshiftObject:@"a"]   #=> ["a", "b", "c", "d"]
 [a unshiftObjects:@[ @1, @2 ]]  #=> [ 1, 2, "a", "b", "c", "d"]
 */
- (void)unshiftObject:(id)obj;
- (void)unshiftObjects:(NSArray *)array;

@end