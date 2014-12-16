//
//  NSZombie.m
//  NSZombieTest
//
//  Created by yuanrui on 14-12-16.
//  Copyright (c) 2014年 KudoCC. All rights reserved.
//

#import "NSZombie.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

void ZombieDealloc(id obj, SEL _cmd) ;
Class ZombifyClass(Class class) ;
NSMethodSignature *ZombieMethodSignatureForSelector(id obj, SEL _cmd, SEL selector) ;
void dump(id obj) ;

void EmptyIMP(id obj, SEL _cmd) {} ;

void EnableZombies(void)
{
    Method m = class_getInstanceMethod([NSObject class], @selector(dealloc));
    method_setImplementation(m, (IMP)ZombieDealloc);
}

void ZombieDealloc(id obj, SEL _cmd)
{
    Class c = ZombifyClass(object_getClass(obj));
    object_setClass(obj, c);
}

Class ZombifyClass(Class class)
{
    NSString *className = NSStringFromClass(class);
    NSString *zombieClassName = [@"NSZombie_" stringByAppendingString: className];
    Class zombieClass = NSClassFromString(zombieClassName);
    if(zombieClass) return zombieClass;
    zombieClass = objc_allocateClassPair(nil, [zombieClassName UTF8String], 0);
    class_addMethod(zombieClass, @selector(methodSignatureForSelector:), (IMP)ZombieMethodSignatureForSelector, "@@::");
    class_addMethod(object_getClass(zombieClass), @selector(initialize), (IMP)EmptyIMP, "v@:");
    objc_registerClassPair(zombieClass);
    
    return zombieClass;
}

NSMethodSignature *ZombieMethodSignatureForSelector(id obj, SEL _cmd, SEL selector)
{
    Class class = object_getClass(obj);
    NSString *className = NSStringFromClass(class);
    NSLog(@"Selector %@ sent to deallocated instance %p of class %@", NSStringFromSelector(selector), obj, className);
    abort();
}

void dump(id obj)
{
    size_t size = malloc_size(obj) ;
    NSLog(@"size:%zu, className:%s", size, object_getClassName(obj)) ;
}

@implementation NSZombie

- (id)init
{
    self = [super init] ;
    if (self) {
        NSIndexSet *obj = [[NSIndexSet alloc] init];
        dump(obj) ;
        [obj release];
        dump(obj) ;
    }
    return self ;
}

+ (void)dump:(id)obj
{
    
}

@end