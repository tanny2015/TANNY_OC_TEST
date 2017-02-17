//
//  main.m
//  6.custom_kvo
//
//  Created by tanny wong on 2017/2/17.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Test6.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
 
        
        Test6 *t6 = [[Test6 alloc] init];
        
        /*GCD 的 main queue 是跑在 runloop 里的, 如果这边没有run，后边GCD里边main queue里的block不跑了*/
        //[[NSRunLoop currentRunLoop] run];
        
    }
    return 0;
}
