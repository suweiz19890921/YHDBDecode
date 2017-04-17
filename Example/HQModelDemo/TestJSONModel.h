//
//  TestJSONModel.h
//  HQModelDemo
//
//  Created by 刘欢庆 on 2017/4/17.
//  Copyright © 2017年 刘欢庆. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TestSub1Model.h"
@interface TestJSONModel : JSONModel
@property (nonatomic, strong) NSArray<TestSub1Model> *subs;
@end
