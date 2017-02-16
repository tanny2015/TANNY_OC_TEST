//
//  Test5.m
//  TANNY_OC_TEST
//
//  Created by tanny wong on 2017/2/16.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import "Test5.h"
#import "User5.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface Test5 ()
@property (nonatomic, strong) NSMutableArray *names;
@property (nonatomic, strong) NSArray *books;

@end

@implementation Test5

-(instancetype)init{
    if(self = [super init]){
        _names = [NSMutableArray array];
        
        
        /*1.测试array的method(objectAtIndex) swizzle*/
        self.books = @[@"book1", @"book2"];
        NSLog(@"%@", self.books[4]);
        /*
         2017-02-16 20:21:46.156 05-runtime[5185:388159] 调用了NSArray tn_objectAtIndex方法
         2017-02-16 20:21:46.156 05-runtime[5185:388159] NSArray tn_objectAtIndex 数组越界
         2017-02-16 20:21:46.156 05-runtime[5185:388159] (null)
         */
        
        /*2.测试NSMutableArray的method(addObject) swizzle*/
        [self.names addObject:@"jack"];
        /*
         2017-02-16 20:22:03.676 05-runtime[5185:388159] 调用了NSMutableArray tn_addObject方法
         2017-02-16 20:22:03.676 05-runtime[5185:388159] 添加成功
         */
        [self.names addObject:@""];
        /*
         2017-02-16 20:22:15.756 05-runtime[5185:388159] 调用了NSMutableArray tn_addObject方法
         2017-02-16 20:22:15.756 05-runtime[5185:388159] 传入字符串长度为0
         */
        
        
        /*3.测试NSMutableArray的method(objectAtIndex) swizzle*/
        NSLog(@"%@", self.names[4]);
        NSLog(@"%@", [self.names objectAtIndex:4]);
        /*
         俩组输入结果均为：
         2017-02-16 20:23:18.294 05-runtime[5185:388159] 调用了NSMutableArray tn_objectAtIndex方法
         2017-02-16 20:23:18.294 05-runtime[5185:388159] (null)
         */
        /*4.测试类成员变量ivars*/
        [self testRuntimeIvar];
        
        
    }
    return self;
}

- (void)testRuntimeIvar{
    // Ivar : 成员变量
    unsigned int count = 0;
    // 获得所有的成员变量
    Ivar *ivars = class_copyIvarList([User5 class], &count);
    for (int i = 0; i<count; i++) {
        // 取得i位置的成员变量
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"%d %s %s", i, name, type);
    }
    /*
     2017-02-16 20:28:32.632 05-runtime[5251:391503] 0 _age i
     2017-02-16 20:28:32.632 05-runtime[5251:391503] 1 _name @"NSString"
     2017-02-16 20:28:32.632 05-runtime[5251:391503] 2 _height d
     
     实际属性表：
     @property (nonatomic, assign) int age;
     @property (nonatomic, copy) NSString *name;
     @property (nonatomic, assign) double height;
     */
    
    //OBJC_EXPORT id objc_msgSend(id self, SEL op, ...)
    User5 *user = [[User5 alloc] init];
    
    /*objc_msgSend() 使用报错解决：
     1.#import <objc/message.h> 
     2.项目配置文件 -> Build Settings -> Enable Strict Checking of objc_msgSend Calls 这个字段设置为 NO
     */
    objc_msgSend(user, @selector(setAge:), 20);
    objc_msgSend(user, @selector(printAge));
    /*
     2017-02-16 20:42:42.204 05-runtime[5366:398332] User5的age = 20
     实际上User5没有开放任何借口，但通过objc_msgSend还是可以改他的数据，调他的.m文件的接口。
     */
    
}

@end
