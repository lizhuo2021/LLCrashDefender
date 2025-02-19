//
//  LLCollectionExceptionHandler.m
//  LLOCKnowledge
//
//  Created by 李琢琢 on 2025/2/18.
//

#import "LLCollectionExceptionHandler.h"

@implementation LLCollectionExceptionHandler

//MARK: - Exception Handler
+ (void)exceptionHandlerWithException:(NSException *)exception {
    if (!exception) {
        return;
    }
    NSString *errorReason = exception.reason;
    NSLog(@"%@", errorReason);
    
    //    记录逻辑
    
    //    其他逻辑
    
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    
    //获取在哪个类的哪个方法中实例化的数组
    //字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [self getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
    
    if (mainCallStackSymbolMsg == nil) {
        
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
    }
    NSString *errorName = exception.name;
    
    NSDictionary *errorInfoDic = @{
        @"ErrorName"        : errorName,
        @"Exception"        : exception,
        @"CallStack"       : mainCallStackSymbolMsg,
        @"CallStackSymbols" : callStackSymbolsArr
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //    发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kLLCollectionExceptionHandlerNotificationName object:nil userInfo:errorInfoDic];
    });
    
}

+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                
                //get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                
                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                    
                }
                *stop = YES;
            }
        }];
        
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    
    return mainCallStackSymbolMsg;
}

@end
