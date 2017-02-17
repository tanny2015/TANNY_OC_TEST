//
//  NSObject+KVO.m
//  ImplementKVO
//
//  Created by Peng Gu on 2/26/15.
//  Copyright (c) 2015 Peng Gu. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const kPGKVOClassPrefix = @"PGKVOClassPrefix_";
NSString *const kPGKVOAssociatedObservers = @"PGKVOAssociatedObservers";


#pragma mark - PGObservationInfo
@interface PGObservationInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) PGObservingBlock block;

@end

@implementation PGObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key block:(PGObservingBlock)block
{
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _block = block;
    }
    return self;
}

@end


#pragma mark - Debug Help Methods
static NSArray *ClassMethodNames(Class c)
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(c, &methodCount);
    unsigned int i;
    for(i = 0; i < methodCount; i++) {
        [array addObject: NSStringFromSelector(method_getName(methodList[i]))];
    }
    free(methodList);
    
    return array;
}


static void PrintDescription(NSString *name, id obj)
{
    NSString *str = [NSString stringWithFormat:
                     @"%@: %@\n\tNSObject class %s\n\tRuntime class %s\n\timplements methods <%@>\n\n",
                     name,
                     obj,
                     class_getName([obj class]),
                     class_getName(object_getClass(obj)),
                     [ClassMethodNames(object_getClass(obj)) componentsJoinedByString:@", "]];
    printf("%s\n", [str UTF8String]);
}


#pragma mark - Helpers
//将"setText:字符串改造成为text字符串"
static NSString * getterForSetter(NSString *setter)
{
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    // lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;
}

//将"text字符串改造成为setText:字符串"
static NSString * setterForGetter(NSString *getter)
{
    if (getter.length <= 0) {
        return nil;
    }
    
    // upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
}


#pragma mark - Overridden Methods
static void kvo_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);//_cmd = setText:  setterName = setText:
    NSString *getterName = getterForSetter(setterName);//getterName = text
    
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    id oldValue = [self valueForKey:getterName];//PGKVOClassPrefix_Message中查找text属性并返回
    
    struct objc_super superclazz = {
        .receiver = self,//PGKVOClassPrefix_Message
        .super_class = class_getSuperclass(object_getClass(self))//Message
    };
    
    // cast our pointer so the compiler won't complain
    //objc_msgSendSuper的理解参照 http://joywii.github.io/blog/2014/09/12/objective-c-superde-li-jie/
    //这个明显是函数指针的赋值
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // call super's setter, which is original class's setter method
    //拿到函数地址后调用
    objc_msgSendSuperCasted(&superclazz, _cmd, newValue);////_cmd = setText: newValue = Hello World!
    
    // look up observers and call the blocks
    // 这个是正题。 从观察者队列中一个个取出来执行block任务
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kPGKVOAssociatedObservers));//数组中只有一个PGObservationInfo对象
    for (PGObservationInfo *each in observers) {
        if ([each.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                each.block(self, getterName, oldValue, newValue);
            });
        }
    }
}


static Class kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}


#pragma mark - KVO Category
@implementation NSObject (KVO)

- (void)PG_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(PGObservingBlock)block
{
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));//setterSelector = setText:
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);//text是ViewController这个测试类的一个属性，所以必然是会有这个方法的。这边就是用属性（而非实例变量）做实验
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        
        return;
    }
    
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);//clazzName == Message
    
    // if not an KVO class yet
    if (![clazzName hasPrefix:kPGKVOClassPrefix]) {
        //给原类新建了一个子类 PGKVOClassPrefix_Message	
        clazz = [self makeKvoClassWithOriginalClassName:clazzName];
        
        object_setClass(self, clazz);
    }
    
    //新建类PGKVOClassPrefix_Message的方法列表打印出来只有一个class方法，就是创建后立即添加上去的，抄的他的父类Message的实现。这边检查一下这个新建类有没有setText:方法，没有的话给他加上
    //
    if (![self hasSelector:setterSelector]) {
        const char *types = method_getTypeEncoding(setterMethod);
        //class_addMethod 参考：http://www.jianshu.com/p/6a3672b8be40。参数1：是需要添加方法的类名 参数2：被添加进入该类的这个方法，此方法在该类中的名称，注意有无参数的格式也得匹配上 参数3：就是参数2对应的那个方法的具体实现，是IMP类型，参数有格式讲究 参数4：传入的参数是什么类型，有几个参数就几个类型加:
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
    }
    
    PGObservationInfo *info = [[PGObservationInfo alloc] initWithObserver:observer Key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kPGKVOAssociatedObservers));//这步断点走完，observers == nil
    //如果当前的观察者列表未初始化，就给他初始化 并且让self(PGKVOClassPrefix_Message)和新建的observers列表产生关联，即类似给一个类添加属性。（上边的class_addMethod 是给一个类添加方法）
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(kPGKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    //观察者列表中添加的元素为PGObservationInfo[包括观察者、key、和block]
    [observers addObject:info];
}


//从观察者数组中移除特定观察者
- (void)PG_removeObserver:(NSObject *)observer forKey:(NSString *)key{
    NSMutableArray* observers = objc_getAssociatedObject(self, (__bridge const void *)(kPGKVOAssociatedObservers));
    
    PGObservationInfo *infoToRemove;
    for (PGObservationInfo* info in observers) {
        if (info.observer == observer && [info.key isEqual:key]) {
            infoToRemove = info;
            break;
        }
    }
    
    [observers removeObject:infoToRemove];
}

//将Message  字符串变成 PGKVOClassPrefix_Message字符串 根据原类去新建一个新的类出来
- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClazzName
{
    NSString *kvoClazzName = [kPGKVOClassPrefix stringByAppendingString:originalClazzName];
    Class clazz = NSClassFromString(kvoClazzName);//新建的这个PGKVOClassPrefix_Message还不一定存在
    
    if (clazz) {
        return clazz;
    }
    
    // class doesn't exist yet, make it
    Class originalClazz = object_getClass(self);
    
    /* OBJC_EXPORT Class objc_allocateClassPair(Class superclass, const char *name,size_t extraBytes)
     
     @param extraBytes The number of bytes to allocate for indexed ivars at the end of
     *  the class and metaclass objects. This should usually be \c 0.
     根据原类去新建一个新的类出来。原类是新类的父类
     */
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);
    
    // grab class method's signature so we can borrow it
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    //给新建的类添加一个类方法
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);
    
    //注册了这个类
    objc_registerClassPair(kvoClazz);
    
    return kvoClazz;
}

//遍历该类的方法列表，查看是否有指定方法。
//新建类PGKVOClassPrefix_Message的方法列表打印出来只有一个class方法，就是创建后立即添加上去的，抄的他的父类Message的实现
- (BOOL)hasSelector:(SEL)selector
{
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(clazz, &methodCount);//这是copy出来的，后边有free
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    
    free(methodList);
    return NO;
}


@end




