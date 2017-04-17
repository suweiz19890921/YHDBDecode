//
//  NSDictionary+util.m
//  GlobleTide
//
//  Created by 杨杰 on 16/1/20.
//  Copyright © 2016年 solot. All rights reserved.
//

#import "NSDictionary+util.h"

@implementation NSDictionary (util)
- (NSString *)toJSON {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
