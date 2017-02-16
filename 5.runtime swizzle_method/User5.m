//
//  User5.m
//  TANNY_OC_TEST
//
//  Created by tanny wong on 2017/2/16.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import "User5.h"

@interface User5()
@property (nonatomic, assign) int age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double height;
@end

@implementation User5
- (void)run{
    NSLog(@"run----");
}

-(void)printAge{
    NSLog(@"User5的age = %d",_age);
}
@end
