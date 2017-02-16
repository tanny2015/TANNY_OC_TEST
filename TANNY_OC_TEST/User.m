//
//  User.m
//  TANNY_OC_TEST
//
//  Created by tanny wong on 2017/2/15.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import "User.h"

@implementation User
+(instancetype)initWithName:(NSString *)name familyName:(NSString *)familyName{
    User *user = [[User alloc] init];
    user.nameStrong = name;
    user.familyNameCopy = familyName;
    NSLog(@"在方法内部：\n 传入的参数:name = %p ,familyName = %p \n",name,familyName);
    NSLog(@"user.nameStrong = %p ,user.familyNameCopy = %p \n",user.nameStrong,user.familyNameCopy);
    
    NSMutableString *mstring = [[NSMutableString alloc] initWithString:@"123"];
    user.addressCopy = mstring;
    NSLog(@"原来的mstring = %p ,user.addressCopy = %p \n",mstring,user.addressCopy);
    return user;
}


@end
