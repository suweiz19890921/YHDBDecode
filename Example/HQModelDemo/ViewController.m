//
//  ViewController.m
//  HQModelDemo
//
//  Created by 刘欢庆 on 2017/4/10.
//  Copyright © 2017年 刘欢庆. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+HQDBDecode.h"
#import "FishDetail.h"
#import "TestModel.h"
#import "TestSub2Model.h"
#import "TestJSONModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [[TestJSONModel alloc] init];
//    NSArray * sss = [FishDetail all];
//    NSMutableArray *news = [NSMutableArray array];
//    for (int i = 0; i < 10; i++)
//    {
//        for (FishDetail *f in sss)
//        {
//            f.ID = [NSString stringWithFormat:@"%@X%@",f.ID,@(i)];
//            [news addObject:f];
//        }
//    }
//    [FishDetail insertAll:news];
//    NSLog(@"更新完成");

}

- (IBAction)kaishi:(id)sender {
    
    [TestModel hq_clearTable];

    TestSub2Model *sub2 = [TestSub2Model new];
    sub2.test1 = @"test111";
    sub2.test1 = @"test222";
    
    TestSub1Model *subdata1 = [TestSub1Model new];
    subdata1.avatar = @"avatar";
    subdata1.shoplist = @[@"xxx1",@"xxx2"];
    subdata1.shopKV = @{@"sub":sub2};
    
    NSData *data = [[NSString stringWithFormat:@"哈哈哈"] dataUsingEncoding:NSUTF8StringEncoding];
    TestModel *t1 = [TestModel new];
    t1.userno = @"222";
    t1.date = [NSDate date];
    t1.metadata = data;
    t1.subdata = [TestSubModel new];
    t1.subdata1 = subdata1;
    t1.subdatas = @[subdata1,subdata1,subdata1];
    t1.imgs = @[@"img1",@"img2",@"img3",@"img4"];
    [t1 hq_insert];

    
    TestModel *t2 = [TestModel new];
    t2.userno = @"333";
    t2.date = [NSDate date];
    t2.metadata = data;
    t2.subdata = [TestSubModel new];
    t1.subdata1 = subdata1;
    t2.subdatas = @[subdata1,subdata1,subdata1];
    t2.imgs = @[@"img1",@"img2",@"img3",@"img4"];
    [t2 hq_insert];

    
    t1.nickname = @"dddddd";
    [t1 hq_update];
//    [TestModel hq_updateByColumns:@{@"userno":@"222"} withDictionary:@{@"nickname":@"xxxx"}];
//    NSArray *a=  [TestModel hq_all];
    NSArray *a=  [TestModel hq_selectByWHERE:@"userno = :no" withDictionary:@{@"no":@"222"}];

    
    for (TestModel *t in a)
    {
        NSLog(@"xxxx %@",[[NSString alloc] initWithData:t.metadata encoding:NSUTF8StringEncoding]);
    }
    NSTimeInterval begin, end;
    
//    begin = CACurrentMediaTime();
//    
//    NSArray * sss = [FishDetail all];
//    
//    end = CACurrentMediaTime();
//    
//    printf("test1:%8.2f  count: %d \n", (end - begin) * 1000,sss.count);
    
    
    begin = CACurrentMediaTime();
    
//    NSArray * sss1 = [FishDetail hq_all];
//    
//    end = CACurrentMediaTime();
//    FishDetail *xx = [FishDetail new];
//    xx.ID = @"测试数据";
//    [xx hq_insert];
//    printf("test2:%8.2f ", (end - begin) * 1000);
    //    for (int i = 0; i < 10; i++) {
    //        for (FishDetail *d in sss) {
    //            d.ID = [NSString stringWithFormat:@"%@_%@",d.latin,@(i)];
    //        }
    //        [FishDetail insertAll:sss];
    //    }
    //    NSLog(@"time %@ sss.cout %@",@([[NSDate date] timeIntervalSince1970] - time),@(sss.count));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
