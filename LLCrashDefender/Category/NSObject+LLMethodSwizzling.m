//
//  NSObject+LLMethodSwizzling.m
//  LLOCKnowledge
//
//  Created by 李琢琢 on 2025/2/17.
//

#import "NSObject+LLMethodSwizzling.h"


@implementation NSObject (LLMethodSwizzling)

#pragma mark - 实例方法处理

+ (void)ll_defenderSwizzlingInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass {
    swizzlingInstanceMethod(targetClass, originalSelector, swizzledSelector);
}

void swizzlingInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    
    //    获取原始方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    
    //    获取替换方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // 尝试添加原方法（防止原方法未实现）。若子类未实现原方法，直接交换会修改父类的方法。通过 class_addMethod 动态添加可避免此问题。
    //    如果子类没有实现这个方法，那么直接添加 原方法名+新方法实现
    BOOL addedOM = class_addMethod(class, originalSelector,
                                   method_getImplementation(swizzledMethod),
                                   method_getTypeEncoding(swizzledMethod)
                                   );
    
    if (addedOM) {
        //        添加成功，说明原来方法确实没实现
        
        //        再进行方法实现替换， 让 新方法名 + 原方法实现 组合。
        class_replaceMethod(class, swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    }else {
        
        //        假如没添加成功，就说明存在原方法，那么直接交换方法实现
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    }
}

#pragma mark - 类方法处理

+ (void)ll_defenderSwizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass {
    swizzlingClassMethod(targetClass, originalSelector, swizzledSelector);
}

void swizzlingClassMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    
    //    获取原始方法
    Method originalMethod = class_getClassMethod(class, originalSelector);
    
    //    获取替换方法
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    // 尝试添加原方法（防止原方法未实现）。若子类未实现原方法，直接交换会修改父类的方法。通过 class_addMethod 动态添加可避免此问题。
    //    如果子类没有实现这个方法，那么直接添加 原方法名+新方法实现
    BOOL addedOM = class_addMethod(class, originalSelector,
                                   method_getImplementation(swizzledMethod),
                                   method_getTypeEncoding(swizzledMethod)
                                   );
    
    if (addedOM) {
        //        添加成功，说明原来方法确实没实现
        
        //        再进行方法实现替换， 让 新方法名 + 原方法实现 组合。
        class_replaceMethod(class, swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    }else {
        
        //        假如没添加成功，就说明存在原方法，那么直接交换方法实现
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    }
}


@end
