//
//  LLCrashSelectorDefenderViewController.m
//  LLOCKnowledge
//
//  Created by 李琢琢 on 2025/2/17.
//

#import "LLCrashSelectorDefenderViewController.h"
#import "LLCollectionExceptionHandler.h"

@interface LLCrashObj : NSObject

- (void)logDoc;

+ (void)calssLog;

@end

@implementation LLCrashObj

@end

@interface LLCrashSelectorDefenderViewController ()<UITextViewDelegate>

@property(nonatomic, strong) UITextView *loggerView;

@end


@implementation LLCrashSelectorDefenderViewController

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
    
    self.title = @"方法未实现";
    
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
        UIButton * button = [self createBlackButtonWithTitle:@"访问未实现实例方法" target:self action:@selector(testCallInstanceMethod)];
        [self.view addSubview:button];
        
        button.frame = CGRectMake(15, statusBarHeight + navigationBarHeight + 10, CGRectGetWidth(self.view.frame) - 30, 30);
        lastButton = button;
    }
    
    {
        UIButton * button = [self createBlackButtonWithTitle:@"访问未实现类方法" target:self action:@selector(testCallClassMethod)];
        [self.view addSubview:button];
        
        button.frame = CGRectMake(15, CGRectGetMaxY(lastButton.frame) + 20, CGRectGetWidth(self.view.frame) - 30, 30);
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

- (void)exceptionErrorNoti:(NSNotification *)noti {
    
    NSDictionary * info = noti.userInfo;
   
    if (info == nil) {
        return;
    }
    self.loggerView.text = [NSString stringWithFormat:@"\n----\n%@", info];
}


- (void)testCallInstanceMethod {
    
    LLCrashObj * obj = [LLCrashObj new];
    
    [obj logDoc];
    
    //            Crash Reason: NSInvalidArgumentException
    //            -[LLCrashObj logDoc]: unrecognized selector sent to instance 0x301de40e0
    //            libc++abi: terminating due to uncaught exception of type NSException
    
}

- (void)testCallClassMethod {
    
    [LLCrashObj calssLog];
    
    //    Crash Reason: NSInvalidArgumentException
    //    +[LLCrashObj calssLog]: unrecognized selector sent to class 0x10285a070
    //    libc++abi: terminating due to uncaught exception of type NSException
    
}

//MARK: - Delgate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}


@end
