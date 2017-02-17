//
//  main.m
//  7.KVO
//
//  Created by tanny wong on 2017/2/17.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"
#import "TwoTimesArray.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //1.测试setValue:forKey
        /*
         Dog* dog = [Dog new];
        [dog setValue:@"newName" forKey:@"name"];
        NSString* name = [dog valueForKey:@"name"];
        NSLog(@"%@",name);
        */
        
        
        
        //2.测试valueForKey:
        /*
         TwoTimesArray：
         @property (nonatomic,readwrite,assign) NSUInteger count;
         @property (nonatomic,copy) NSString* arrName;
         */
        TwoTimesArray* arr = [TwoTimesArray new];
        NSNumber* num =   [arr valueForKey:@"num"];
        NSLog(@"%@",num);
        
        
        id ar = [arr valueForKey:@"numbers"];
        NSLog(@"%@",NSStringFromClass([ar class]));
        NSLog(@"0:%@     1:%@     2:%@     3:%@",ar[0],ar[1],ar[2],ar[3]);
        
        
        [arr incrementCount];                      //count加1
        NSLog(@"%lu",(unsigned long)[ar count]);   //打印出1
        
        
        [arr incrementCount];                      //count再加1
        NSLog(@"%lu",(unsigned long)[ar count]);   //打印出2
        
        
        [arr setValue:@"newName" forKey:@"arrName"];
        NSString* name = [arr valueForKey:@"arrName"];
        NSLog(@"%@",name);
        //打印结果
        /*
         2017-02-17 20:31:27.071437 7.KVO[5626:195005] 10 //调用了getNum
         2017-02-17 20:31:27.071793 7.KVO[5626:195005] NSKeyValueArray
         2017-02-17 20:31:27.071844 7.KVO[5626:195005] 0:0     1:2     2:4     3:6
         2017-02-17 20:31:27.071859 7.KVO[5626:195005] 1
         2017-02-17 20:31:27.071868 7.KVO[5626:195005] 2
         2017-02-17 20:31:27.072257 7.KVO[5626:195005] newName
         很明显，上面的代码充分说明了说明了KVC在调用ValueforKey：@”name“时搜索key的机制。不过还有些功能没有全部列出，有兴趣的读者可以写代码去验证。
         */

        
         
        
        
    }
    return 0;
}



