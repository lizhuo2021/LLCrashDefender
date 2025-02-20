//
//  LLKeyChainHelper.h
//
//  Created by 李琢琢 on 2025/1/15.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 用来标识这个钥匙串
static NSString * const KEYCHAIN_COMMON_SERVICE = @"com.lizhuo.app.keychain";
// 用来标识密码
static NSString * const KEYCHAIN_KEY_PWD = @"com.lizhuo.app.pwd";

static NSString * const KEYCHAIN_KEY_OTHER = @"com.lizhuo.app.other";

@interface LLKeyChainHelper : NSObject

// 保存字符串到钥匙串
+ (BOOL)saveString:(NSString *)string
            forKey:(NSString *)key
           service:(NSString *)service
             error:(NSError **)error;

// 从钥匙串读取字符串
+ (NSString *)stringForKey:(NSString *)key
                   service:(NSString *)service
                     error:(NSError **)error;

// 删除钥匙串条目
+ (BOOL)deleteItemForKey:(NSString *)key
                 service:(NSString *)service
                   error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
