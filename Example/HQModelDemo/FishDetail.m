//
//  FishDetail.m
//  Catches
//
//  Created by solot on 16/3/2.
//  Copyright © 2016年 solot. All rights reserved.
//

#import "FishDetail.h"

@implementation FishDetail

//+ (NSArray *)selectImageByLatins:(NSArray *)latins
//{
//    NSMutableArray *array = [NSMutableArray array];
//    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:[FishDetail class]];
//    NSMutableString *where = [NSMutableString string];
//    [where appendString:@"('"];
//    NSString *latinStr = [latins componentsJoinedByString:@"', '"];
//    [where appendString:latinStr];
//    [where appendString:@"')"];
//    [queue inDatabase:^(FMDatabase *db) {
////        NSString *sql = [NSString stringWithFormat:@"SELECT img FROM FishDetail WHERE latin in %@ AND language = ?", where];
//        NSString *sql = [NSString stringWithFormat:@"SELECT img FROM FishIndex WHERE latin in %@ ORDER BY latin", where];
//        FMResultSet *rs = [db executeQuery:sql, [GlobalConfig dataBaseLanguage]];;
//        while ([rs next]) {
//            NSString *image = [rs stringForColumn:@"img"];
//            if (![NSString isBlankString:image]) {
//                [array addObject:image];
//            }
//        }
//    }];
//    return array;
//}
@end
