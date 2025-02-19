//
//  LLCollectionExceptionHandler.h
//  LLOCKnowledge
//
//  Created by 李琢琢 on 2025/2/18.
//

#import <Foundation/Foundation.h>

static NSString * const kLLCollectionExceptionHandlerNotificationName = @"kLLCollectionExceptionHandlerNotificationName";

NS_ASSUME_NONNULL_BEGIN

@interface LLCollectionExceptionHandler : NSObject

+ (void)exceptionHandlerWithException:(NSException *)exception;

+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols;

@end

NS_ASSUME_NONNULL_END
