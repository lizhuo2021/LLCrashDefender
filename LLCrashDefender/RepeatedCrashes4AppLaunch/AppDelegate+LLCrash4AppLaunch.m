//
//  AppDelegate+LLCrash4AppLaunch.m
//  LLCrashDefender
//
//  Created by 李琢琢 on 2025/2/20.
//

#import "AppDelegate+LLCrash4AppLaunch.h"
#import "NSObject+LLMethodSwizzling.h"

@implementation AppDelegate (LLCrash4AppLaunch)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 交换实例方法
        [NSObject ll_defenderSwizzlingInstanceMethod:@selector(application:didFinishLaunchingWithOptions:) withMethod:@selector(ll_application:didFinishLaunchingWithOptions:) withClass:[AppDelegate class]];
        
        
    });
    
}

- (BOOL)ll_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    
    self.crashHelper = [LLCrash4AppLaunchHelper new];
    
    if (launchOptions != nil) {
        return [self ll_application:application didFinishLaunchingWithOptions:launchOptions];
    }
    
    //    需要修复页面走这里
    self.crashHelper.repairBlock = ^{
        [LLCrash4AppLaunchHelper setRepairPageIsRootViewController];
    };
    
    //    正常启动走这里
    __weak __typeof(self)weakSelf = self;
    self.crashHelper.completionBlock = ^BOOL{
        // 执行原didFinishLaunchingWithOptions方法
        return [weakSelf ll_application:application didFinishLaunchingWithOptions:launchOptions];
    };
    
    return [self.crashHelper appLaunchCrashProtect];
}

@end
