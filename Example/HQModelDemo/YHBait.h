//
//  YHBait.h
//  Catches
//
//  Created by 刘欢庆 on 2017/7/27.
//  Copyright © 2017年 solot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHBait : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSDictionary *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, assign) long long updateTime;
@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *seriesId;

- (NSString *)nameByUseLanguage;
@end
