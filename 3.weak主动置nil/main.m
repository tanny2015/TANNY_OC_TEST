//
//  main.m
//  3.weak主动置nil
//
//  Created by tanny wong on 2017/2/15.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "test3.h"


int main(int argc, const char * argv[]) {
    

    @autoreleasepool {
        // insert code here...
        
       
        test3 *t3 = [[test3 alloc] init];
        [t3 func];
        
        NSLog(@"3. t3.array = %p",t3.array);
      
    /*打印结果：
     1.arr = 0x1002025b0, &arr = 0x7fff5fbff6f8
     _array = 0x0, &_array = 0x1002064d8
     
     
     2.arr = 0x1002025b0, &arr = 0x7fff5fbff6f8
     _array = 0x1002025b0, &_array = 0x1002064d8
     
     
     3. t3.array = 0x1002025b0
     */
    }
    
   
    return 0;
}

