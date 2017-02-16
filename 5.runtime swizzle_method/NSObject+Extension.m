//
//  NSObject+Extension.m
//  TANNY_OC_TEST
//
//  Created by tanny wong on 2017/2/16.
//  Copyright © 2017年 tanny wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#pragma mark - **************    NSObject    **************

@implementation NSObject (Extension)
/*
 RUNTIME：
 1.一套底层的C语言API（包含很多强大实用的C语言数据类型、C语言函数） 平时编写的OC代码，底层都是基于runtime实现，最终都是转成了底层runtime代码（C语言）
 
 2.可动态产生|修改|删除 一个类、一个成员变量、一个方法
 
 3.#import <objc/runtime.h> : 成员变量、类、方法
 [示例]
 Method * class_copyMethodList : 获得某个类内部的所有方法
 Method class_getInstanceMethod : 获得某个实例方法（对象方法，减号-开头）
 Method class_getClassMethod : 获得某个类方法（加号+开头）
 method_exchangeImplementations : 交换2个方法的具体实现
 
 4.#import <objc/message.h> : 消息机制
 [示例] objc_msgSend(....)
   
 
 5.这个文件演示swizzleMethod [即上述3中最后一项：method_exchangeImplementations]
 
 6.swizzleMethod 实际上是 调换A和B俩个方法，让编译器调A的时候，让它转到B上去。
 6.1 更多时候的情况为：A是系统类自带方法，如NSArray的objectAtIndex: 而即将让她转到的B方法是人为自定义的custom_objectAtIndex,而B一般是拓展了A，例如B在原来A的基础上加入了一个if判断过滤掉一些，当然也可以是其他的。
 
 6.2 类的load() 系统第一次将文件加载进内存的时候调用,系统类会自动加载进来，就会把这个类的分类一起加载到内存中去，swizzle操作在load中进行还是比较保险的。
 
 */

//先自定义俩个common方法，为swizzleMethod的处理
//1.交换类方法实现
+ (void)swizzleClassMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector{
    
    Method otherMehtod = class_getClassMethod(class, otherSelector);
    Method originMehtod = class_getClassMethod(class, originSelector);
    method_exchangeImplementations(otherMehtod, originMehtod);// 交换2个方法的实现
}
//2.交换实例方法实现
+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector{
    
    Method otherMehtod = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    method_exchangeImplementations(otherMehtod, originMehtod);
}
@end




#pragma mark - **************    NSArray    **************

@implementation NSArray(Extension)
+ (void)load{
    //__NSArrayI这个是NSArray的底层实现（类似kvo的底层实现？可能是运行时生成的），其中后边的I是imutable的意思
    //a[4] 实际底层调用的是 objectAtIndex:
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSelector:@selector(objectAtIndex:) otherSelector:@selector(tn_objectAtIndex:)];
}

//调用objectAtIndex:方法的时候，会自动切换调用到这个方法
//这个swizzle方法作为原来objectAtIndex的改良，主要是过滤了越界访问导致奔溃的问题，然后打一个log
- (id)tn_objectAtIndex:(NSUInteger)index{
    
    NSLog(@"调用了NSArray tn_objectAtIndex方法");
    //把index越界的问题给避免掉【也不一定是好处，没有报错找不到出错点】
    if (index < self.count) {
        return [self tn_objectAtIndex:index];//使用tn_objectAtIndex，调用这个方法实际上是调用原来NSArray自带的objectAtIndex:方法，如果调用了objectAtIndex:方法，实际上是调用tn_objectAtIndex本身，会导致死循环

    } else {
        NSLog(@"NSArray tn_objectAtIndex 数组越界");
        return nil;
    }
}

@end





#pragma mark - **************    NSMutableArray    **************

@implementation NSMutableArray(Extension)
+ (void)load{
    
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(addObject:) otherSelector:@selector(tn_addObject:)];
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndex:) otherSelector:@selector(tn_objectAtIndex:)];
}
//重写addObject方法
//这个swizzle方法作为原来addObject的改良，主要是过滤了添加空值这种没有意义的操作
- (void)tn_addObject:(id)object{
    
    NSLog(@"调用了NSMutableArray tn_addObject方法");
    
    if ([object isKindOfClass:[NSString class]] && [object length] == 0) {
        NSLog(@"传入字符串长度为0");
        return;
    }
    
    [self tn_addObject:object];
    NSLog(@"添加成功");
}

//这个swizzle方法作为原来objectAtIndex的改良，主要是过滤了越界访问导致奔溃的问题，然后打一个log
- (id)tn_objectAtIndex:(NSUInteger)index{
    
    NSLog(@"调用了NSMutableArray tn_objectAtIndex方法");
    if (index < self.count) {
        return [self tn_objectAtIndex:index];
    } else {
        return nil;
    }
}
@end












