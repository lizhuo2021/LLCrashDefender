//
//  LLCrash4AppLaunchHelper.h
//  LLCrashDefender
//
//  Created by 李琢琢 on 2025/2/20.
//

#import <UIKit/UIKit.h>

#define LLCrash4AppLaunchHelperClearCountTime 10
#define LLCrash4AppLaunchHelperMaxCrashCount 3

typedef void(^LLCrash4AppLaunchHelperRepairBlock)(void);
typedef BOOL(^LLCrash4AppLaunchHelperCompletionBlock)(void);


NS_ASSUME_NONNULL_BEGIN

@interface LLCrash4AppLaunchHelper : NSObject

@property(nonatomic, copy) LLCrash4AppLaunchHelperRepairBlock repairBlock;
@property(nonatomic, copy) LLCrash4AppLaunchHelperCompletionBlock completionBlock;

- (BOOL)appLaunchCrashProtect;
/// 清空Crash计数
+ (void)clearCrashCount;

+ (void)setRepairPageIsRootViewController;

+ (void)setDefaultPageIsRootViewController;


@end

NS_ASSUME_NONNULL_END
