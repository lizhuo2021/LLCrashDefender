//
//  LLCrashKVCViewController.m
//  LLOCKnowledge
//
//  Created by 李琢琢 on 2025/2/17.
//

#import "LLCrashKVCViewController.h"
#import "LLCollectionExceptionHandler.h"

#import "LLUserModel.h"

@interface LLCrashKVCViewController ()<UITextViewDelegate>

@property(nonatomic, strong) UITextView *loggerView;

@property(nonatomic, strong) LLUserModel *user;

@end

@implementation LLCrashKVCViewController

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
    
    
    self.user = [LLUserModel new];
}

- (void)setupSubviews {
    
    self.title = @"KVC Crash";
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
        UIButton * button = [self createBlackButtonWithTitle:@"key 不是对象的属性" target:self action:@selector(testKVCSetValueForUndefinedKey)];
        [self.view addSubview:button];
        
        button.frame = CGRectMake(15, statusBarHeight + navigationBarHeight + 10, CGRectGetWidth(self.view.frame) - 30, 30);
        lastButton = button;
    }
    
    {
        UIButton * button = [self createBlackButtonWithTitle:@"keyPath 不正确" target:self action:@selector(testKVCSetValueForUndefinedKeyPath)];
        [self.view addSubview:button];
        
        button.frame = CGRectMake(15, CGRectGetMaxY(lastButton.frame) + 20, CGRectGetWidth(self.view.frame) - 30, 30);
        lastButton = button;
    }
    
    {
        UIButton * button = [self createBlackButtonWithTitle:@"key 为 nil" target:self action:@selector(testKVCSetValueNil)];
        [self.view addSubview:button];
        
        button.frame = CGRectMake(15, CGRectGetMaxY(lastButton.frame) + 20, CGRectGetWidth(self.view.frame) - 30, 30);
        lastButton = button;
    }
    
    {
        UIButton * button = [self createBlackButtonWithTitle:@"value 为 nil" target:self action:@selector(testKVCSetValueNilNSNumberOrNSValue)];
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



//key 不是对象的属性，造成崩溃。
- (void)testKVCSetValueForUndefinedKey {

    [self.user setValue:@"男" forKey:@"gender"];
    
    /*
     Crash Reason: NSUnknownKeyException
     [<LLUserModel 0x301b35760> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key gender.
     */
    
    
}

//keyPath 不正确，造成崩溃。
- (void)testKVCSetValueForUndefinedKeyPath {

    [self setValue:@"123123" forKeyPath:@"user.id"];
    
}

//key 为 nil，造成崩溃。建议手动判断
- (void)testKVCSetValueNil {

    NSString * key;
    if (key == nil) {
        return;
    }
    [self.user setValue:@"张三" forKey:key];
    
}

//value 为 nil，为非对象设值，造成崩溃
- (void)testKVCSetValueNilNSNumberOrNSValue {

//    其他对象类型。如果value为nil。没有事。
    [self.user setValue:nil forKey:@"userName"];
//    username为nil
    NSLog(@"%@",self.user.name);
    
//    key对应的value。如果可以转为NSNumber、NSValue，如果为nil，会触发 setNilValueForKey 方法。
//    [self.user setValue:nil forKey:@"age"];
    
}

//MARK: - Delgate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}


@end
