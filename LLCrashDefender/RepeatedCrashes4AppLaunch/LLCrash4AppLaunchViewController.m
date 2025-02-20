//
//  LLCrash4AppLaunchViewController.m
//  LLCrashDefender
//
//  Created by 李琢琢 on 2025/2/19.
//

#import "LLCrash4AppLaunchViewController.h"
#import "LLCollectionExceptionHandler.h"

@interface LLCrash4AppLaunchViewController ()<UITextViewDelegate>

@property(nonatomic, strong) UITextView *loggerView;

@end

@implementation LLCrash4AppLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configData];
    [self setupSubviews];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//MARK: - Private

- (void)configData {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exceptionErrorNoti:) name:kLLCollectionExceptionHandlerNotificationName object:nil];
    
}

- (void)setupSubviews {
    
    self.title = @"持续的App启动崩溃";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton * lastButton;
    
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
    
    {
        UIButton * button = [self createBlackButtonWithTitle:@"写入损坏数据" target:self action:@selector(testWriteDamagedData4NSUserDefaults:)];
        [button setTitle:@"删除损坏数据"  forState:UIControlStateSelected];
        [self.view addSubview:button];
        
        button.frame = CGRectMake(15, statusBarHeight + navigationBarHeight + 10, CGRectGetWidth(self.view.frame) - 30, 30);
        lastButton = button;
    }
    
    
    //    loggerView
    CGFloat loggerViewHeight = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(lastButton.frame) - 50;
    self.loggerView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastButton.frame) + 50, CGRectGetWidth(self.view.frame), loggerViewHeight)];
    self.loggerView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.loggerView.delegate = self;
    self.loggerView.backgroundColor = UIColor.blackColor;
    self.loggerView.textColor = UIColor.whiteColor;
    [self.view addSubview:self.loggerView];
    
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

//MARK: - Events

- (void)testWriteDamagedData4NSUserDefaults:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    if (sender.isSelected) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LLCrashSaveKey"];
        
    }else {
        
        // 写入非法数据（NSData 伪装成 NSString）
        NSData *corruptedData = [NSData dataWithBytes:"\xff\xfe\xff" length:3];
        [[NSUserDefaults standardUserDefaults] setObject:corruptedData forKey:@"LLCrashSaveKey"];
        
        self.loggerView.text = @"写入损坏数据完毕，现在可以杀掉并重新打开App";
        
    }
    sender.selected = !sender.isSelected;
    
}

//MARK: - Delgate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}


@end
