//
//  DBInit.m
//  CameraRuler
//
//  Created by LiuHuanQing on 15/4/8.
//  Copyright (c) 2015年 HQ_L. All rights reserved.
//

#import "DBInit.h"
#import "HQDatabaseManager.h"

#define CHAT_DB_NAME @"chat.db"
#define STORE_DB_NAME @"store.db"

#import "FishDetail.h"
@implementation DBInit

+ (void)load
{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *pathInDocument = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:DB_NAME];
    BOOL isExist = [filemanager fileExistsAtPath:pathInDocument];
    if (!isExist) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:DB_NAME ofType:nil];
        NSError *error;
        BOOL success = [filemanager copyItemAtPath:path toPath:pathInDocument error:&error];
        if (success) {
            NSLog(@"拷贝成功");
            isExist = YES;
        }
    }    
//            执行加密data.db 从APP中data.db拷贝出来,替换Resources中的data.db
//    [SQLiteCipher encryptDatabase:pathInDocument];

    [[HQDatabaseManager sharedInstance] createDBQueue:DB_NAME withTalbe:@[[FishDetail class]]];

}

+ (void)dbInit
{
//
//    NSFileManager *filemanager = [NSFileManager defaultManager];
//    NSString *pathInDocument = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:DB_NAME];
//    BOOL isExist = [filemanager fileExistsAtPath:pathInDocument];
//    if (!isExist) {
//        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"data.db" ofType:nil];
//        NSError *error;
//        BOOL success = [filemanager copyItemAtPath:path toPath:pathInDocument error:&error];
//        if (success) {
//            NSLog(@"拷贝成功");
//            isExist = YES;
//        }
//    }
//
////    [[HQDatabaseManager sharedInstance] createDBQueue:DB_NAME withTalbe:@[[FishDetail class], [FishFamily class], [FishOrder class], [FishIndex class], [FishResource class], [CountryModel class], [FishingModel class], [FishPlaceModel class],[FishRecord class],[FishBait class],[TextBookModel class]]];
//    
//    [[HQDatabaseManager sharedInstance] createDBQueue:DB_NAME withTalbe:@[[FishDetail class],
//                                                                          [FishFamily class],
//                                                                          [FishOrder class],//
//                                                                          [FishIndex class],//
//                                                                          [AppResource class],//资源
//                                                                          [CountryModel class],
//                                                                          [FishingModel class],
//                                                                          [FishPlaceModel class],
//                                                                          [FishRecord class],
//                                                                          [TextBookModel class],
//                                                                          [DirectoryModel class],
//                                                                          [FishBait class],
//                                                                          [FishTempModel class],
//                                                                          [TideModel class],
//                                                                          [TideStationModel class],
//                                                                          [GeocodeModel class],
//                                                                          [MyFishRecord class],
//                                                                          [MyFishPlaceModel class],
//                                                                          [AdministrationModel class],
//                                                                          [DistrictModel class],
//                                                                          [ADModel class],
//                                                                          [TimeWeatherModel class],
//                                                                          [HQProduct class],
//                                                                          [SSTModel class],
//                                                                          [MyFishBait class],
//                                                                          [MyCollectionModel class]
//                                                                          ]];
//    
//    //草稿
//    [[HQDatabaseManager sharedInstance] createDBQueue:DRAFT_DB_NAME withTalbe:@[[DraftModel class], [DraftBodyModel class],[TopicModel class]]];
//    
//    [[HQDatabaseManager sharedInstance] createDBQueue:CHAT_DB_NAME withTalbe:@[[ChatUserModel class],[ChatSessionModel class],[ChatMessageModel class],[ChatApplyFriendsModel class],[AddressModel class],[ChatGroupModel class],[ChatMemberModel class],[ChatUserinfoModel class],[ChatNoticeModel class],[ChatBlackModel class],[ChatSessionCSModel class],[ChatShopModel class]]];
//    
//    //话题
//    [[HQDatabaseManager sharedInstance] createDBQueue:STORY_NAME withTalbe:@[[MyUploadingModel class],[MyVideoModel class],[HotStorieModel class],[HotClientStoryModel class], [StorySummaryModel class]]];
//    
//    //商场
//    [[HQDatabaseManager sharedInstance] createDBQueue:STORE_DB_NAME withTalbe:@[[StoreCartModel class]]];
}


@end
