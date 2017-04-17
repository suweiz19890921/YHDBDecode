//
//  TestModel.h
//  HQModelDemo
//
//  Created by 刘欢庆 on 2017/4/17.
//  Copyright © 2017年 刘欢庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestSubModel.h"
#import "TestSub1Model.h"
@interface TestModel : NSObject
@property (nonatomic, strong) NSString *userno;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSData *metadata;
@property (nonatomic, strong) TestSubModel *subdata;
@property (nonatomic, strong) TestSub1Model *subdata1;
@property (nonatomic, strong) NSArray *subdatas;
@property (nonatomic, strong) NSArray *imgs;
@end
