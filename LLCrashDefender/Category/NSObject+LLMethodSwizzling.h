//
//  NSObject+LLMethodSwizzling.h
//  LLOCKnowledge
//
//  Created by 李琢琢 on 2025/2/17.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LLMethodSwizzling)

+ (void)ll_defenderSwizzlingInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass;

+ (void)ll_defenderSwizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass;

@end

NS_ASSUME_NONNULL_END
