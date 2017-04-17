//
//  TestSub1Model.h
//  HQModelDemo
//
//  Created by 刘欢庆 on 2017/4/17.
//  Copyright © 2017年 刘欢庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestSub2Model.h"
@protocol TestSub1Model <NSObject>
@end

@interface TestSub1Model : NSObject
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSArray *shoplist;
@property (nonatomic, strong) NSDictionary<NSString *,TestSub2Model *> *shopKV;
@end
