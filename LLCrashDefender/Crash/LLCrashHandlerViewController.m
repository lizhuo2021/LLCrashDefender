//
//  LLCrashHandlerViewController.m
//  练习测试
//
//  Created by 李琢琢 on 2025/1/13.
//

#import "LLCrashHandlerViewController.h"


@interface LLCrashHandlerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation LLCrashHandlerViewController

#pragma mark - Controller Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDataSource];
    [self configSubviews];
}

#pragma mark - Private


- (void)configDataSource {
    {
        LLCommonTableListCellData * cellData = [LLCommonTableListCellData new];
        cellData.cellName = @"LLCrashSelectorDefenderViewController";
        cellData.showTitle = @"方法未实现";
        
        [self.dataSource addObject:cellData];
    }
    {
        LLCommonTableListCellData * cellData = [LLCommonTableListCellData new];
        cellData.cellName = @"LLCrashKVCViewController";
        cellData.showTitle = @"KVC";
        
        [self.dataSource addObject:cellData];
    }
    
}
- (void)configSubviews {
    self.title = @"Crash防护";
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    [self.view addSubview:self.tableView];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self.tableView reloadData];
}

#pragma mark - Public

#pragma mark - Actions


#pragma mark - Delegate

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLCommonTableListCellData *cellData= [self.dataSource objectAtIndex:indexPath.row];
    LLCommonTableListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellData.cellName];
    
    if (!cell &&
        cellData.cellName) {
        cell = [[LLCommonTableListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:cellData.cellName];
    }
    
    cell.textLabel.text = cellData.showTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LLCommonTableListCellData *cellData= [self.dataSource objectAtIndex:indexPath.row];
    
    UIViewController * viewController = [[NSClassFromString(cellData.cellName) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Getter

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

@end

