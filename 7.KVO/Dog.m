//
//  Dog.m
//  TANNY_OC_TEST
//
//  Created by tanny wong on 2017/2/17.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import "Dog.h"

@implementation Dog{
    NSString* toSetName;
    NSString* isName;
    //NSString* name;
    NSString* _name;
    NSString* _isName;
}



// -(void)setName:(NSString*)name{
//     toSetName = name;
// }
//-(NSString*)getName{
//    return toSetName;
//}


+(BOOL)accessInstanceVariablesDirectly{
    return NO;
}
-(id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在%@",key);
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在%@",key);
}
@end
