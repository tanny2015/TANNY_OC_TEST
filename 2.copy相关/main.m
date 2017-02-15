//
//  main.m
//  2.copy相关
//
//  Created by tanny wong on 2017/2/15.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *name =  @"tanny";
        NSString *familyName = @"wong";
        NSLog(@"在方法内外部：\n name = %p ,familyName = %p \n",name,familyName);
        User *user = [User initWithName:name familyName:familyName];
        
        /*打印结果
        1.在方法内外部：
        name = 0x1000020f8 ,familyName = 0x100002118
        2.在方法内部：
        传入的参数:name = 0x1000020f8 ,familyName = 0x100002118
        user.nameStrong = 0x1000020f8 ,user.familyNameCopy = 0x100002118
        3.原来的mstring = 0x1002007d0 ,user.addressCopy = 0x33323135 
         
        结论
         使用copy的效用，是为了杜绝一种情况：OC的Array NSString之类的类型有可变类型，可有array = mutableArray这种子向父赋值的情况，由于指针同指向一个位置，可能会让array和string这种不可变类型指向的区域被改乱了，就让遵循copy协议，让可变向不可变指针赋值的时候，另外开一块区域给不可变新指针指着。
         
         1.array = mutableArray 当array由copy修饰时，赋值符号会自动对右边进行copy操作，至于结果直接参照可变不可变的copy规律就行了。就是所谓的深浅复制了。 否则直接用strong修饰得手写 array = [mutable copy]
         2.上方的familyName虽然是copy修饰，但是他是string不可变类型，使用copy后仍然是浅复制，所以还是和原来指针指向同一块区域了，但是这样也没有什么妨碍，因为 像 string = string这样的，右侧也同样是不可变类型，不存在他们指向的内存空间的东西被他人修改的情况。【这种情况和用strong修饰基本上效果是一致的】
         
         */
        
    }
    return 0;
}
