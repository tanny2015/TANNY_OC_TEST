//
//  User.h
//  TANNY_OC_TEST
//
//  Created by tanny wong on 2017/2/15.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property(nonatomic,strong)NSString *nameStrong;
@property(nonatomic,copy)  NSString *familyNameCopy;
@property(nonatomic,copy)  NSString *addressCopy;
+(instancetype)initWithName:(NSString *)name familyName:(NSString *)familyName ;
@end
