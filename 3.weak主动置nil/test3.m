//
//  test3.m
//  TANNY_OC_TEST
//
//  Created by tanny wong on 2017/2/15.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import "test3.h"

@implementation test3

-(void)func{
    NSArray *arr = [NSArray array];
    NSLog(@"1.arr = %p, &arr = %p",arr,&arr);
    NSLog(@"_array = %p, &_array = %p",_array,&_array);
    _array = arr;
    NSLog(@"2.arr = %p, &arr = %p",arr,&arr);
    NSLog(@"_array = %p, &_array = %p",_array,&_array);
}

@end
