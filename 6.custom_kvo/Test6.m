//
//  Test6.m
//  TANNY_OC_TEST
//
//  Created by tanny wong on 2017/2/17.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import "Test6.h"
#import "NSObject+KVO.h"
@interface Message : NSObject
@property (nonatomic, copy) NSString *text;
@end

@implementation Message
@end







@interface Test6 ()
@property (nonatomic, strong) Message *message;
@property (nonatomic, strong) NSString *result;
@end


/*这个全部用单步调试看起来会很快理顺的*/
@implementation Test6

- (instancetype)init
{
    self = [super init];
    if (self) {
        _message = [[Message alloc] init];
        
        [_message PG_addObserver:self forKey:NSStringFromSelector(@selector(text))
                       withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
                           
                           NSLog(@"%@.%@ is now: %@", observedObject, observedKey, newValue);
                           self.result = newValue;
                           NSLog(@"kvo block被调用，self.result = %@",self.result);
                       }];
        
        [self changeMessage];
    }
    return self;
}


- (void)changeMessage
{
    NSArray *msgs = @[@"Hello World!", @"Objective C", @"Swift", @"Peng Gu", @"peng.gu@me.com", @"www.gupeng.me", @"glowing.com"];
    NSUInteger index = arc4random_uniform((u_int32_t)msgs.count);
    NSLog(@"self.message.text = %@",msgs[index]);
    self.message.text = msgs[index];
}

@end
