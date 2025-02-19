//
//  NSObject+LLSelectorDefender.h
//  LLOCKnowledge
//
//  Created by 李琢琢 on 2025/2/17.
//

/*
 通过将不存在的方法。转发给动态中间对象。使动态中间对象来处理。
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LLSelectorDefender)

@end

NS_ASSUME_NONNULL_END
