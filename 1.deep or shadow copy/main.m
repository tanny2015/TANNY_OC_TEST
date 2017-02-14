//
//  main.m
//  1.deep or shadow copy
//
//  Created by tanny wong on 2017/2/14.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import <Foundation/Foundation.h>
//浅复制就是指针拷贝；深复制就是内容拷贝。
//指针的值是他所指向内存的地址，指针的地址是该类型指针本身在内存中占用空间的地址
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
      //1、非集合类对象的copy与mutableCopy,系统非集合类对象指的是 NSString, NSNumber ... 之类的对象。
      //1.1 非集合不可变对象拷贝
        /* ----------------
        NSString *string = @"origin";
        NSLog(@"string所指向的地址为：%p",string);
       //a.copy
        NSString *stringCopy = [string copy];
        NSLog(@"copy生成的字符串所指向的地址为：%p",stringCopy);
       //b.mutableCopy
        NSMutableString *stringMCopy = [string mutableCopy];
        NSLog(@"mutableCopy生成的字符串所指向的地址为：%p",stringMCopy);
       //c.initWithString
        NSString *string_new = [[NSString alloc] initWithString:string];
        NSLog(@"initWithString生成的字符串所指向的地址为：%p",string_new);
         ----------------- */
        
        /*
         打印结果：
         string所指向的地址为：0x100001040
         copy生成的字符串所指向的地址为：0x100001040
         mutableCopy生成的字符串所指向的地址为：0x100300300
         initWithString生成的字符串所指向的地址为：0x100001040
         结论：
         1.使用copy，initWithString作用于 不可变非集合对象 ，生成的对象【也是 不可变非集合对象】指向的内存地址不变
         2.使用mutableCopy作用于 不可变非集合对象 ，生成的对象【是 可变非集合对象】指向的内存地址改变
         */
        
        //1.2 非集合可变对象拷贝
        /*----------
        NSMutableString *string = [NSMutableString stringWithString: @"origin"];
        NSLog(@"string所指向的地址为：%p",string);
        //copy
        NSString *stringCopy = [string copy];
        NSLog(@"copy生成的字符串所指向的地址为：%p",stringCopy);
        
        NSMutableString *stringMCopy = [string mutableCopy];
        NSLog(@"mutableCopy生成的字符串所指向的地址为：%p",stringMCopy);
        
        //NSMutableString *mStringCopy = [string copy];
        //[mStringCopy appendString:@"mm"]; //NSMutableString 是 NSString子类，从生成过程可知实际类型只是NSString，NSString无appendString方法导致奔溃
         
         ---------*/
        
        /*打印结果：
         string所指向的地址为：0x100208d00
         copy生成的字符串所指向的地址为：0x6e696769726f65
         mutableCopy生成的字符串所指向的地址为：0x100500070
         结论：
         1.使用copy，stringWithString,mutableCopy作用于 可变非集合对象 ，生成的对象【也是 可变非集合对象】指向的内存地址都发生改变
         */
        
        /*
         综合1.1 和 1.2 可得到结论
         在非集合类对象中：对immutable对象进行copy操作，是指针复制，mutableCopy操作时内容复制；对mutable对象进行copy和mutableCopy都是内容复制。用代码简单表示如下：
         
         [immutableObject copy] // 浅复制
         [immutableObject mutableCopy] //深复制
         [mutableObject copy] //深复制
         [mutableObject mutableCopy] //深复制
         */
        
        
        
        //2、集合类对象的copy与mutableCopy（集合类对象是指NSArray、NSDictionary、NSSet ... 之类的对象）
        //2.1不可变集合对象
        /* ----------
        NSArray *array = @[@[@"a", @"b"], @[@"c", @"d"]];
        NSLog(@"0.array指向的内存地址是：%p,array[0]也是数组指针，它指向的内存地址是：%p",array,array[0]);
        
        NSArray *copyArray = [array copy];
        NSLog(@"1.[copy]copyArray指向的内存地址是：%p,copyArray[0]也是数组指针，它指向的内存地址是：%p",copyArray,copyArray[0]);
        
        NSMutableArray *mCopyArray = [array mutableCopy];
        NSLog(@"2.[MutableCopy]mCopyArray指向的内存地址是：%p,mCopyArray[0]也是数组指针，它指向的内存地址是：%p",mCopyArray,mCopyArray[0]);
        ------------- */
        
        /*打印结果：
         0.array指向的内存地址是：0x1002026b0,array[0]也是数组指针，它指向的内存地址是：0x100200560
         1.[copy]copyArray指向的内存地址是：0x1002026b0,copyArray[0]也是数组指针，它指向的内存地址是：0x100200560
         2.[MutableCopy]mCopyArray指向的内存地址是：0x100600450,mCopyArray[0]也是数组指针，它指向的内存地址是：0x100200560
         结论：【和1.1不可变非集合结论一致】
         1.使用copy，initWithString作用于 不可变集合对象 ，生成的首集合对象【也是 不可变集合对象】指向的内存地址不变
         2.使用mutableCopy作用于 不可变集合对象 ，生成的集合对象【是 可变集合对象】指向的内存地址改变
         3.生成的这个集合对象中子对象不发生改变，原样搬运。
         */
        
        //2.2可变集合对象
        
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
        NSLog(@"0.array指向的内存地址是：%p,array[0]是数组指针指向内存地址：%p,array[1]是字符串指针指向内存地址：%p",array,array[0],array[1]);
        NSArray *copyArray = [array copy];
        NSLog(@"1.[copy]copyArray指向的内存地址是：%p,copyArray[0]也是数组指针，它指向的内存地址是：%p,copyArray[1]是字符串指针指向内存地址：%p",copyArray,copyArray[0],copyArray[1]);

        NSMutableArray *mCopyArray = [array mutableCopy];
        NSLog(@"2.[MutableCopy]mCopyArray指向的内存地址是：%p,mCopyArray[0]也是数组指针，它指向的内存地址是：%p,mCopyArray[1]是字符串指针指向内存地址：%p",mCopyArray,mCopyArray[0],mCopyArray[1]);
        /*
         打印结果：
         0.array指向的内存地址是：0x100203150,array[0]是数组指针指向内存地址：0x100208420,array[1]是字符串指针指向内存地址：0x100001068
         1.[copy]copyArray指向的内存地址是：0x1005001a0,copyArray[0]也是数组指针，它指向的内存地址是：0x100208420,copyArray[1]是字符串指针指向内存地址：0x100001068
         2.[MutableCopy]mCopyArray指向的内存地址是：0x100500220,mCopyArray[0]也是数组指针，它指向的内存地址是：0x100208420,mCopyArray[1]是字符串指针指向内存地址：0x100001068
         结论：和可变非集合对象的结论一致
         1.使用copy，arrayWithObjects,mutableCopy作用于 可变集合对象 ，生成的对象【也是 可变集合对象】指向的内存地址都发生改变
         2.生成的这个集合对象中子对象不发生改变，原样搬运。
         */
        
        /*
         综合2.1  2.2可得：
         在集合类对象中，对不可变对象进行copy，是指针复制，mutableCopy是内容复制；对mutable对象进行copy和mutableCopy都是内容复制。但是：集合对象的内容复制仅限于对象本身，内部元素仍然是指针复制。用代码简单表示如下：
         
         [immutableObject copy] // 浅复制
         [immutableObject mutableCopy] //单层深复制
         [mutableObject copy] //单层深复制
         [mutableObject mutableCopy] //单层深复制
         */
        
        NSLog(@"Hello, World!");
    }
    return 0;
}
