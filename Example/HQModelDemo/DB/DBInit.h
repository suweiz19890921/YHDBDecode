//
//  DBInit.h
//  CameraRuler
//
//  Created by LiuHuanQing on 15/4/8.
//  Copyright (c) 2015年 HQ_L. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DB_NAME @"localData.db"
#define STORY_NAME @"story.db"
@interface DBInit : NSObject
+ (void)dbInit;
@end
