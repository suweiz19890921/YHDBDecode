//
//  HQModelClassProperty.h
//  CameraRuler
//
//  Created by LiuHuanQing on 15/4/3.
//  Copyright (c) 2015年 HQ_L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface HQModelClassProperty : NSObject
+ (HQModelClassProperty *)property:(objc_property_t)property;
@property (nonatomic,assign) BOOL isPrimaryKey;//主键
@property (nonatomic,assign) BOOL isUnique;//唯一值
@property (nonatomic,assign) BOOL is;
@property (nonatomic,strong) NSString *name;//属性名称
@property (nonatomic,strong) NSString *type;//属性类型
@end
