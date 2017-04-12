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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FishDetail hq_dataWithResultSet:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
