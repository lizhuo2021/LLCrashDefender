//
//  LLCrash4AppLaunchRepairViewController.m
//  LLCrashDefender
//
//  Created by 李琢琢 on 2025/2/20.
//

#import "LLCrash4AppLaunchRepairViewController.h"
#import "LLCrash4AppLaunchHelper.h"

@interface LLCrash4AppLaunchRepairViewController ()

@end

@implementation LLCrash4AppLaunchRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
    
}

//MARK: Private

- (void)setupSubviews {
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"应用修复";
    
    UILabel *tip = [UILabel new];
    tip.text = @"App出现异常，请点击下方修复按钮开始修复";
    [self.view addSubview:tip];
    
    UIButton * fix = [self createBlackButtonWithTitle:@"开始修复" target:self action:@selector(fixButtonAction:)];
    [self.view addSubview:fix];
    
    UIButton * cancel = [self createBlackButtonWithTitle:@"取消并退出App" target:self action:@selector(cancelButtonAction:)];
    [self.view addSubview:cancel];
    
    
    CGFloat statusBarHeight = 0;
    
//    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
//    }else {
//        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//    }
    
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    tip.frame = CGRectMake(15, statusBarHeight + navigationBarHeight + 20, CGRectGetWidth(self.view.frame) - 30, 30);
    
    fix.frame = CGRectMake(15, CGRectGetMaxY(tip.frame) + 50, CGRectGetWidth(self.view.frame) - 30, 40);
    
    cancel.frame = CGRectMake(15, CGRectGetMaxY(fix.frame) + 20, CGRectGetWidth(self.view.frame) - 30, 40);
    
}

- (UIButton *)createBlackButtonWithTitle:(NSString *)title
                                target:(id)target
                                action:(SEL)action {
    
    UIButton * button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.blackColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
    
}




//MARK: Events

- (void)fixButtonAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    // 删除数据
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LLCrashSaveKey"];
    
    // 删除 Documents Library Caches 目录下所有文件
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSArray *filePathsToRemove = @[documentsDirectory, libraryDirectory, cachesDirectory];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    for (NSString *filePath in filePathsToRemove) {
        if ([fileMgr fileExistsAtPath:filePath]) {
            NSArray *subFileArray = [fileMgr contentsOfDirectoryAtPath:filePath error:nil];
            for (NSString *subFileName in subFileArray) {
                NSString *subFilePath = [filePath stringByAppendingPathComponent:subFileName];
                [fileMgr removeItemAtPath:subFilePath error:nil];
            }
        }
    }

    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修复完毕，请重新打开App" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        清空crash计数，重新设置根控制器标记
        [LLCrash4AppLaunchHelper clearCrashCount];
        [LLCrash4AppLaunchHelper setDefaultPageIsRootViewController];
        
        
        exit(0);
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)cancelButtonAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
//    不做处理。直接退出
    exit(0);
}


@end
