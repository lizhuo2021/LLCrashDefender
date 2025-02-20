//
//  AppDelegate.m
//  LLCrashDefender
//
//  Created by 李琢琢 on 2025/2/19.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 强制以错误类型读取（直接崩溃）
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"LLCrashSaveKey"];
    NSInteger a = [value integerValue]; // EXC_BAD_ACCESS 崩溃点
    
    NSLog(@"原App启动逻辑处理");
    
    [self configureGlobalNavigationBar];
    
    return YES;
}

- (void)configureGlobalNavigationBar {
    
    // 创建外观配置对象
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    
    // 配置背景颜色（适配深色模式）
    [appearance setBackgroundColor:[UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [UIColor blackColor] : [UIColor whiteColor];
    }]];
    
    // 设置标题文字属性
    [appearance setTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor labelColor],  // 系统动态颜色
        NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]
    }];
    
    // 设置大标题属性（需要开启prefersLargeTitles）
    [appearance setLargeTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor labelColor],
        NSFontAttributeName: [UIFont systemFontOfSize:34 weight:UIFontWeightBold]
    }];
    
    // 移除底部阴影线
    [appearance setShadowColor:[UIColor clearColor]];
    
    // 应用所有导航栏状态
    [[UINavigationBar appearance] setStandardAppearance:appearance];
    [[UINavigationBar appearance] setCompactAppearance:appearance];
    [[UINavigationBar appearance] setScrollEdgeAppearance:appearance];
    
    // 设置返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor systemBlueColor]];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
