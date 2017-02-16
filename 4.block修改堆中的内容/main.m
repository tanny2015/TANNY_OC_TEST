//
//  main.m
//  4.block修改堆中的内容
//
//  Created by tanny wong on 2017/2/16.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

/** 这个代码参照了ChenYilong github中的示例 **/
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        //test1 -- 使用__block将栈区搬到堆上进行修改
        
        __block int a = 0;//编译器检测到底下有个block里边捕获到这个a，他就转移了。在block被实际调用之前就移动了
        NSLog(@"定义前：%p", &a);         //栈区
        void (^foo)(void) = ^{
            a = 1;
            NSLog(@"block内部：%p", &a);    //堆区
        };
        NSLog(@"定义后：%p", &a);         //堆区 __block标记了这个a变量，捕获后a带有__block修饰符，直接开了个内存放值，此时后续所有的a都是这个堆区的a了
        foo();
        
        /*
         打印结果：
         定义前：0x7fff5fbff728
         定义后：0x1002024f8
         block内部：0x1002024f8
         */
        
        
        
        
        /*测试2  */
        /*
        NSMutableString *a = [NSMutableString stringWithString:@"Tom"];
        NSLog(@"\n 定以前：a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
        void (^foo)(void) = ^{
            a.string = @"Jerry";
            NSLog(@"\n block内部：a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
            //a = [NSMutableString stringWithString:@"William"];//编译不通过，那是因为此时你在修改的就不是堆中的内容，而是栈中的内容
        };
        foo();
        NSLog(@"\n 定以后：a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
        */
        /*打印结果
         定以前：a指向的堆中地址：0x100205480；a在栈中的指针地址：0x7fff5fbff728
         block内部：a指向的堆中地址：0x100205480；a在栈中的指针地址：0x100303770
         定以后：a指向的堆中地址：0x100205480；a在栈中的指针地址：0x7fff5fbff728
         
         a指向的堆中地址保持不变，因为block只是捕获了指针的值，开了个新指针去盛装这个值，指针的值本身就是
         指向堆区，因此复制了一个指针不会影响指向的。
         */
        
        /*
         综合1 2 ：
         Block不允许修改外部变量的值，这里所说的外部变量的值，指的外部变量的在内存中的原始地址
         如：基本变量传入前地址是0x11，那么在block被执行后，该基本变量在内存中占用地址还是0x11，除非被__block修饰了
         如：指针变量传入前地址是0x56，那么在block被执行后，该基本变量在内存中占用地址还是0x56. 指的是指针本身在内存中的地址，不是他指向的内存地址。
         */
        NSLog(@"Hello, World!");
    }
    return 0;
}
