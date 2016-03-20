//
//  MyOperation.m
//  UI22_多线程
//
//  Created by dllo on 15/6/18.
//  Copyright (c) 2015年 dllo. All rights reserved.
//

#import "MyOperation.h"

@implementation MyOperation

-(void)main
{
    // 这个方法不论调用与否都会走这个方法
    // 一般把任务写在这个方法里
    NSInteger a = 0;
    for (NSInteger i = 0; i < 600000000; i++) {
        a++;
    }
    NSLog(@"%ld",a);
}













@end
