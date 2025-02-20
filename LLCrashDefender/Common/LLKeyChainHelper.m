//
//  LLKeyChainHelper.h
//
//  Created by 李琢琢 on 2025/1/15.

#import "LLKeyChainHelper.h"

#import<Security/Security.h>

@implementation LLKeyChainHelper

#pragma mark - 基础查询字典
+ (NSMutableDictionary *)baseQuery:(NSString *)key
                           service:(NSString *)service {
    return [@{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount: key,
        (__bridge id)kSecAttrService: service,
        (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleAfterFirstUnlock
    } mutableCopy];
}

#pragma mark - 保存数据
+ (BOOL)saveString:(NSString *)string
            forKey:(NSString *)key
           service:(NSString *)service
             error:(NSError **)error {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        if (error) *error = [NSError errorWithDomain:@"KeychainError"
                                                code:-1
                                            userInfo:@{NSLocalizedDescriptionKey: @"String encoding failed"}];
        return NO;
    }
    
    NSMutableDictionary *query = [self baseQuery:key service:service];
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    
    if (status == errSecSuccess) { // 存在则更新
        NSDictionary *update = @{(__bridge id)kSecValueData: data};
        status = SecItemUpdate((__bridge CFDictionaryRef)query,
                               (__bridge CFDictionaryRef)update);
    } else if (status == errSecItemNotFound) { // 不存在则新增
        query[(__bridge id)kSecValueData] = data;
        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }
    
    if (status != errSecSuccess && error) {
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                     code:status
                                 userInfo:nil];
    }
    return status == errSecSuccess;
}

#pragma mark - 读取数据
+ (NSString *)stringForKey:(NSString *)key
                   service:(NSString *)service
                     error:(NSError **)error {
    
    NSMutableDictionary *query = [self baseQuery:key service:service];
    query[(__bridge id)kSecReturnData] = @YES;
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    if (status != errSecSuccess) {
        if (error) *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                                code:status
                                            userInfo:nil];
        return nil;
    }
    
    NSData *data = (__bridge_transfer NSData *)result;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - 删除数据
+ (BOOL)deleteItemForKey:(NSString *)key
                 service:(NSString *)service
                   error:(NSError **)error {
    
    NSMutableDictionary *query = [self baseQuery:key service:service];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    if (status != errSecSuccess && error) {
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                     code:status
                                 userInfo:nil];
    }
    return status == errSecSuccess;
}


@end
