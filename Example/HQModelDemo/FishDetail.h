//
//  FishDetail.h
//  Catches
//
//  Created by solot on 16/3/2.
//  Copyright © 2016年 solot. All rights reserved.
//


#import "FishBaseModel.h"
/**
 *  鱼详细信息表
 */
@interface FishDetail : FishBaseModel
/**
 *  ID
 */
@property (nonatomic, strong) NSString<PrimaryKey> *ID;
/**
 *  鱼名称
 */
@property (nonatomic, strong) NSString<Optional> *name;
/**
 *  鱼别名
 */
@property (nonatomic, strong) NSString<Optional> *fishAlias;
/**
 *  鱼形态
 */
@property (nonatomic, strong) NSString<Optional> *fishForm;
/**
 *  鱼分布
 */
@property (nonatomic, strong) NSString<Optional> *distribution;
/**
 *  鱼类生息环境
 */
@property (nonatomic, strong) NSString<Optional> *habitats;
/**
 *  鱼类食性特点
 */
@property (nonatomic, strong) NSString<Optional> *characteristics;
/**
 *  其他补充
 */
@property (nonatomic, strong) NSString<Optional> *other;
/**
 *  语言
 */
@property (nonatomic, strong) NSString *language;
/**
 *  特征简介
 */
@property (nonatomic, strong) NSString<Optional> *feature;

/**
 *  最后更新时间
 */
@property (nonatomic, assign) long long lastTime;
/**
 *  状态：0未审核，-1删除，1审核通过
 */
@property (nonatomic, assign) NSInteger status;
/**
 *  拉丁名
 */
@property (nonatomic, strong) NSString *latin;

/**
 *  首图
 */
@property (nonatomic, strong) NSString<Optional> *img;
/**
 *  图库(不包含首图)
 */
@property (nonatomic, strong) NSString<Optional> *imgs;


@property (nonatomic, strong) NSString <Optional>*traumaRisks;

@property (nonatomic, strong) NSString <Optional>*foodRisks;


+ (NSArray *)selectImageByLatins:(NSArray *)latins;

//+ (NSArray *)searchFishDetailWithKeyword:(NSArray *)keyword;
@end
