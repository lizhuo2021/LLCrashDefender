//
//  NSObject+LLKVCCrashDefender.m
//  LLOCKnowledge
//
//  Created by 李琢琢 on 2025/2/17.
//

#import "NSObject+LLKVCCrashDefender.h"
#import "LLCollectionExceptionHandler.h"
#import "NSObject+LLMethodSwizzling.h"

@implementation NSObject (LLKVCCrashDefender)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        hook setValue:forKey: 确实会出现很多问题，不建议这样做。
        
//        [NSObject ll_defenderSwizzlingInstanceMethod:@selector(setValue:forKey:)
//                                          withMethod:@selector(ll_setValue:forKey:)
//                                           withClass:[NSObject class]];
    });
    
}

//对于KVC中的这两个方法，进行处理
//setValue:forKey: 执行失败会调用 setValue: forUndefinedKey: 方法，并引发崩溃。
//valueForKey: 执行失败会调用 valueForUndefinedKey: 方法，并引发崩溃。
//所以，为了进行 KVC Crash 防护，我们就需要重写 setValue: forUndefinedKey: 方法和 valueForUndefinedKey: 方法。
//重写这两个方法之后，就可以防护 1. key 不是对象的属性 和 2. keyPath 不正确 这两种崩溃情况了。
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
    NSException * exce = [NSException exceptionWithName:@"KVC Error" reason:@"找不到key相关属性" userInfo:nil];
    [LLCollectionExceptionHandler exceptionHandlerWithException:exce];
    
    NSLog(@"KVC赋值错误：找不到key相关属性：%@", key);
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    
    NSException * exce = [NSException exceptionWithName:@"KVC Error" reason:@"找不到key相关属性" userInfo:nil];
    [LLCollectionExceptionHandler exceptionHandlerWithException:exce];
    
    NSLog(@"KVC取值错误：找不到key相关属性：%@", key);
    
    return self;
}

////对于key为nil的处理：
//// 进行方法交换，对nil来加一层判断。
//- (void)ll_setValue:(id)value forKey:(NSString *)key {
//    if (key == nil) {
//        NSLog(@"KVC取值错误：key为nil");
//        return;
//    }
//    [self ll_setValue:value forKey:key];
//}

/*
 对于value为nil的情况：重写 setNilValueForKey 即可，默认是出发crash
 假设调用-setValue:forKey:将无法设置键值，因为相应访问器方法的参数类型是NSNumber标量类型或NSValue结构类型，但值为nil，请使用其他机制设置键值。此方法的默认实现会引发NSInvalidArgumentException。您可以重写它，将nil值映射到应用程序上下文中有意义的值。
*/
- (void)setNilValueForKey:(NSString *)key {
    
    NSException * exce = [NSException exceptionWithName:@"KVC Error" reason:@"value为nil" userInfo:nil];
    [LLCollectionExceptionHandler exceptionHandlerWithException:exce];
    
    NSLog(@"KVC赋值错误：value为nil");
}


@end
