//
//  NSObject+LLSelectorDefender.m
//  LLOCKnowledge
//
//  Created by 李琢琢 on 2025/2/17.
//

#import "NSObject+LLSelectorDefender.h"
#import "NSObject+LLMethodSwizzling.h"
#import "LLCollectionExceptionHandler.h"

@implementation NSObject (LLSelectorDefender)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 交换实例方法
//        [NSObject ll_defenderSwizzlingInstanceMethod:@selector(forwardingTargetForSelector:) withMethod:@selector(ll_forwardingTargetForSelector:) withClass:[NSObject class]];
//        
//        // 交换类方法
//        [NSObject ll_defenderSwizzlingClassMethod:@selector(forwardingTargetForSelector:) withMethod:@selector(ll_forwardingTargetForSelector:) withClass:[NSObject class]];
//    });
//    
//}


static int selectorNotfoundError(id self, SEL selector) {
    return 0;
}


#pragma mark - 实例方法处理

-(id)ll_forwardingTargetForSelector:(SEL)aSeletor {
    
    // 在load中发生了方法交换, 此处取ll_forwardingTargetForSelector才能获取真正的forwardingTargetForSelector的imp
    SEL forwarding_sel = @selector(ll_forwardingTargetForSelector:);
    
    // 拿到NSObject的forward方法。
    Method root_forwarding_method = class_getInstanceMethod([NSObject class], forwarding_sel);
    // 拿到当前类的 转发 方法
    Method current_forwarding_method = class_getInstanceMethod([self class], forwarding_sel);
    
    // 判断当前类是否实现了forwardingTargetForSelector
    // 当前类的实现和NSObject类的实现一样，那说明 当前类没实现
    BOOL realize = method_getImplementation(current_forwarding_method) != method_getImplementation(root_forwarding_method);
    
    if (!realize) {
        // 在判断 当前类 是否实现了 methodSignatureForSelector
        SEL methodSignature_sel = @selector(methodSignatureForSelector:);
        
        // 拿到NSObject的 methodSignatureForSelector方法。
        Method root_methodSignature_method = class_getInstanceMethod([NSObject class], methodSignature_sel);
        
        // 拿到当前类的 methodSignatureForSelector 方法
        Method current_methodSignature_method = class_getInstanceMethod([self class], methodSignature_sel);
        
        // 判断当前类是否实现了 methodSignatureForSelector
        realize = method_getImplementation(current_methodSignature_method) != method_getImplementation(root_methodSignature_method);
        
        // 假如没有实现。我们动态创建中间类，并且实现方法
        if (!realize) {
            // 获取没实现的类名
            NSString * errorClassName = NSStringFromClass([self class]);
            
            // 获取为实现的方法名
            NSString * errorSEL = NSStringFromSelector(aSeletor);
            
//            NSLog(@"类：%@，实例方法，-%@", errorClassName, errorSEL);
            
            NSException * exce = [NSException exceptionWithName:@"NSInvalidArgumentException" reason:[NSString stringWithFormat:@"'-[%@ %@]: unrecognized selector sent to instance %p", errorClassName, errorSEL, self] userInfo:nil];
            [LLCollectionExceptionHandler exceptionHandlerWithException:exce];
            
            // 动态创建中间类
            NSString *className = @"LLSelectorCrachClass";
            
            Class cls = NSClassFromString(className);
            
            if (!cls) {
                Class superClass = [NSObject class];
                // 创建类
                cls = objc_allocateClassPair(superClass, className.UTF8String, 0);
                // 注册类
                objc_registerClassPair(cls);
            }
            
            // 如果类没有对应的方法，给他添加一个
            if (!class_getInstanceMethod(cls, aSeletor)) {
                class_addMethod(cls, aSeletor, (IMP)selectorNotfoundError, "@@:@");
            }
            
            return [[cls alloc] init];
        }
    }
    return [self ll_forwardingTargetForSelector:aSeletor];
}

#pragma mark - 类方法处理

+ (id)ll_forwardingTargetForSelector:(SEL)aSeletor {
    
    // 在load中发生了方法交换, 此处取ll_forwardingTargetForSelector才能获取真正的forwardingTargetForSelector的imp
    SEL forwarding_sel = @selector(ll_forwardingTargetForSelector:);
    
    // 拿到NSObject的forward方法。
    Method root_forwarding_method = class_getClassMethod([NSObject class], forwarding_sel);
    
    // 拿到当前类的 转发 方法
    Method current_forwarding_method = class_getClassMethod([self class], forwarding_sel);
    
    // 判断当前类是否实现了forwardingTargetForSelector
    // 当前类的实现和NSObject类的实现一样，那说明 当前类没实现
    BOOL realize = method_getImplementation(current_forwarding_method) != method_getImplementation(root_forwarding_method);
    
    if (!realize) {
        
        // 在判断 当前类 是否实现了 methodSignatureForSelector
        SEL methodSignature_sel = @selector(methodSignatureForSelector:);
        
        // 拿到NSObject的 methodSignatureForSelector方法。
        Method root_methodSignature_method = class_getClassMethod([NSObject class], methodSignature_sel);
        
        // 拿到当前类的 methodSignatureForSelector 方法
        Method current_methodSignature_method = class_getClassMethod([self class], methodSignature_sel);
        
        // 判断当前类是否实现了 methodSignatureForSelector
        realize = method_getImplementation(current_methodSignature_method) != method_getImplementation(root_methodSignature_method);
        
        // 假如没有实现。我们动态创建中间类，并且实现方法
        if (!realize) {
            // 获取没实现的类名
            NSString * errorClassName = NSStringFromClass([self class]);
            // 获取为实现的方法名
            NSString * errorSEL = NSStringFromSelector(aSeletor);
            
            NSException * exce = [NSException exceptionWithName:@"NSInvalidArgumentException" reason:[NSString stringWithFormat:@"+[%@ %@]: unrecognized selector sent to class %p", errorClassName, errorSEL, self] userInfo:nil];
            [LLCollectionExceptionHandler exceptionHandlerWithException:exce];
            
            // 动态创建中间类
            NSString *className = @"LLSelectorCrachClass";
            
            Class cls = NSClassFromString(className);
            if (!cls) {
                Class superClass = [NSObject class];
                // 创建类
                cls = objc_allocateClassPair(superClass, className.UTF8String, 0);
                // 注册类
                objc_registerClassPair(cls);
            }
            
            // 如果类没有对应的方法，给他添加一个
            if (!class_getInstanceMethod(cls, aSeletor)) {
                class_addMethod(cls, aSeletor, (IMP)selectorNotfoundError, "@@:@");
            }
            return [[cls alloc] init];
        }
    }
    return [self ll_forwardingTargetForSelector:aSeletor];
}

@end
