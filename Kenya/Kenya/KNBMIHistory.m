//
//  KNBMIHistory.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNBMIHistory.h"
#import "KNTableView.h"
#import "KNBMIHistoryCell.h"
#import "KNBMIDataModel.h"
#import "KNBMIModel.h"
#import "KNBMIDetail.h"
#import "KNChartViewController.h"

@interface KNBMIHistory ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) KNTableView *tableView;
@property (nonatomic, strong) KNBMIDataModel *dataModel;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UILabel *emptyLab;

@end

@implementation KNBMIHistory

- (void)dealloc {
    [self.dataModel removeObserver:self forKeyPath:@"dictionary"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"记录";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"趋势" style:UIBarButtonItemStylePlain target:self action:@selector(showGraph)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editRecords)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    [self.dataArray removeAllObjects];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.dataArray removeAllObjects];
    [self.dataModel getBMIHistoryDict];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataModel = [[KNBMIDataModel alloc] init];
        self.dataArray = [NSMutableArray array];
        
        [self.dataModel addObserver:self forKeyPath:@"dictionary" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)showGraph {
    NSMutableArray *xLabels = [NSMutableArray array];
    NSMutableArray *yData = [NSMutableArray array];
    for (NSInteger i = self.dataArray.count - 1;i >= 0;i--) {
        KNBMIModel *model = (KNBMIModel *)self.dataArray[i];
        [xLabels addObject:model.dateStr];
        [yData addObject:[NSNumber numberWithFloat:model.weight]];
    }
    KNChartViewController *vc = [[KNChartViewController alloc] initWithLabels:xLabels yData:yData];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)editRecords {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing){
        [self.navigationItem.leftBarButtonItem setTitle:@"完成"];
    } else {
        [self.navigationItem.leftBarButtonItem setTitle:@"编辑"];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataModel.dictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    NSString *month;
    NSEnumerator *keys = [self.dataModel.dictionary keyEnumerator];
    while (month = [keys nextObject]) {
        if (count == section) {
            break;
        }
        count++;
    }
    return [[self.dataModel.dictionary objectForKey:month] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int count = 0;
    NSString *month;
    NSEnumerator *keys = [self.dataModel.dictionary keyEnumerator];
    while (month = [keys nextObject]) {
        if (count == indexPath.section) {
            break;
        }
        count++;
    }
    NSArray *modArray = [self.dataModel.dictionary objectForKey:month];
    KNBMIHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[KNBMIHistoryCell reuseID] forIndexPath:indexPath];
    if (!cell) {
        cell = [[KNBMIHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[KNBMIHistoryCell reuseID]];
    }
    KNBMIModel *mod = [modArray objectAtIndex:indexPath.row];
    [cell updateCell:mod.index date:mod.dateStr weight:mod.weight];
    if (![self.dataArray containsObject:mod]) {
        [self.dataArray addObject:mod];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int count = 0;
    NSString *month;
    NSEnumerator *keys = [self.dataModel.dictionary keyEnumerator];
    while (month = [keys nextObject]) {
        if (count == indexPath.section) {
            break;
        }
        count++;
    }
    NSArray *modArray = [self.dataModel.dictionary objectForKey:month];
    KNBMIModel *mod = [modArray objectAtIndex:indexPath.row];
    KNBMIDetail *detailVC = [[KNBMIDetail alloc] initWithBMIModel:mod];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _F(55);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int count = 0;
        NSString *month;
        NSEnumerator *keys = [self.dataModel.dictionary keyEnumerator];
        while (month = [keys nextObject]) {
            if (count == indexPath.section) {
                break;
            }
            count++;
        }
        NSMutableArray *modArray = [self.dataModel.dictionary objectForKey:month];
        NSUInteger row = [indexPath row];
        KNBMIModel *mod = [modArray objectAtIndex:indexPath.row];
        [[[KNBMIDataModel alloc] init] deleteBMIRecord:mod];
        [[self.dataModel.dictionary objectForKey:month] removeObjectAtIndex:row];
        [self.dataArray removeObjectAtIndex:row];
    
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    int count = 0;
    NSString *month;
    NSEnumerator *keys = [self.dataModel.dictionary keyEnumerator];
    while (month = [keys nextObject]) {
        if (count == section) {
            break;
        }
        count++;
    }

    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:[KNConfig groupTableColor]];
    UILabel *label = [[UILabel alloc] init];
    [label setText:month];
    [label setFont:[UIFont systemFontOfSize:_F(_Size13)]];
    [titleView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleView);
    }];
    return titleView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (void)addEmptyView {
    [self.emptyView addSubview:self.emptyLab];
    [_tableView addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tableView);
        make.size.mas_equalTo(CGSizeMake(_ScreenWidth, _F(50)));
    }];
    [self.emptyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.emptyView);
        make.size.mas_equalTo(CGSizeMake(_ScreenWidth, _F(50)));
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"dictionary"]) {
        if ([change objectForKey:NSKeyValueChangeNewKey] == [NSNull null]) {
            return;
        }
        [self.tableView reloadData];
        if ([self.dataModel.dictionary count] <= 0) {
            [self addEmptyView];
        } else {
            [self.emptyView removeFromSuperview];
        }
    }
}

#pragma mark - Getter & Setter

- (KNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[KNTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[KNBMIHistoryCell class] forCellReuseIdentifier:[KNBMIHistoryCell reuseID]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] init];
    }
    return _emptyView;
}

- (UILabel *)emptyLab {
    if (!_emptyLab) {
        _emptyLab = [[UILabel alloc] init];
        [_emptyLab setText:@"目前还没有记录哦"];
        [_emptyLab setFont:[UIFont systemFontOfSize:_F(_Size16)]];
        [_emptyLab setTextColor:[KNConfig grayColor]];
        [_emptyLab setTextAlignment:NSTextAlignmentCenter];
    }
    return _emptyLab;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (void)didReceiveMemoryWarning {
[super didReceiveMemoryWarning];
// Dispose of any resources that can be recreated.
}
*/

@end
