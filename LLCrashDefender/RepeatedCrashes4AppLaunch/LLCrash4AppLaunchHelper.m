//
//  LLCrash4AppLaunchHelper.m
//  LLCrashDefender
//
//  Created by 李琢琢 on 2025/2/20.
//


#import "LLCrash4AppLaunchHelper.h"
#import "LLCrash4AppLaunchRepairViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
@interface LLCrash4AppLaunchHelper ()

@property(nonatomic, assign) NSUInteger crashCount;

@property(nonatomic, assign) NSUInteger clearCountTime;

@end

@implementation LLCrash4AppLaunchHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.crashCount = LLCrash4AppLaunchHelperMaxCrashCount;
        
        self.clearCountTime = LLCrash4AppLaunchHelperClearCountTime;
        
//        添加用户手动从前台杀掉App通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillTerminateWithNoti:)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:[UIApplication sharedApplication]];
        
    }
    return self;
}

- (void)dealloc {
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//MARK: Public

+ (void)clearCrashCount {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"kLLCrash4AppLaunchHelperKeyCrashCount"];
}

+ (void)setRepairPageIsRootViewController {
    // 如果是用旧版单场景 AppDelegate 来处理根控制器，可以直接修改根控制器
    // 这里用 SceneDelegate 处理。在 application:didFinishLaunchingWithOptions:期间，
    // SceneDelegate还为nil。所以通过保存值来处理。用其他方法保存值也可以。
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kSceneDelegateShowRepairPage"];

}

+ (void)setDefaultPageIsRootViewController {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kSceneDelegateShowRepairPage"];

}


- (BOOL)appLaunchCrashProtect {
    
//    开始检查crash次数
    self.crashCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"kLLCrash4AppLaunchHelperKeyCrashCount"];

    NSLog(@"当前crash次数%ld", self.crashCount);
    
    if (self.crashCount >= LLCrash4AppLaunchHelperMaxCrashCount - 1) {
        //    修复逻辑
        
        NSLog(@"进入修复页面");
        //        调用修复逻辑block
        if (self.repairBlock) {
            self.repairBlock();
        }
        
        return YES;
    }else {
        //        正常逻辑
        NSLog(@"crash次数未到最大值");
//        增加计数
        self.crashCount += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:self.crashCount forKey:@"kLLCrash4AppLaunchHelperKeyCrashCount"];
        
        // 启动计时，如果活过这个时间，说明App没有出现启动崩溃
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.clearCountTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            NSLog(@"启动已超过预设秒数，App没有crash");
            [self clearCrashCount];
        });
//        调用正常逻辑block
        if (self.completionBlock) {
            return self.completionBlock();
        }
        
        return NO;
    }
    
    return NO;
}


//MARK: Private

- (void)clearCrashCount {
    self.crashCount = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:self.crashCount forKey:@"kLLCrash4AppLaunchHelperKeyCrashCount"];
}


//MARK: Events

-(void)applicationWillTerminateWithNoti:(NSNotification *)noti{
    NSLog(@"前台手动杀死App，清空计数");
    [self clearCrashCount];
}


@end
