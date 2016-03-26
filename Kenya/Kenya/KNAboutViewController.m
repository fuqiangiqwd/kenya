//
//  KNAboutViewController.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNAboutViewController.h"
#import "KNTableView.h"
#import "KNAboutBMIView.h"
#import <MessageUI/MessageUI.h>
#import "KNDeviceInfo.h"
#import "KNNotification.h"

@interface KNAboutViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) KNTableView *tableView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIButton *webBtn;
@property (nonatomic, strong) UIButton *weiboBtn;
@property (nonatomic, strong) UIButton *emailBtn;
@property (nonatomic, strong) UILabel *verLab;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) BOOL isDatePickerOn;

@end

@implementation KNAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于";
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.verLab];
    [self.view addSubview:self.webBtn];
    [self.view addSubview:self.weiboBtn];
    [self.view addSubview:self.emailBtn];
    [self.view addSubview:self.datePicker];

    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(_F(75));
        make.size.mas_equalTo(CGSizeMake(_F(66), _F(66)));
    }];
    [self.verLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_ScreenWidth);
        make.top.equalTo(self.verLab.mas_bottom).with.offset(_F(-20));
        make.center.equalTo(self.view);
    }];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.webBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
    [self.weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.webBtn.mas_bottom).offset(_F(-5));
    }];
    [self.emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.weiboBtn.mas_bottom).offset(_F(-5));
    }];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(_F(-60));
    }];
    self.isDatePickerOn = NO;
}

- (void)displayComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"应用反馈"];
    NSArray *toRecipients = [NSArray arrayWithObject:@"fuqiangiqwd@126.com"];
    [picker setToRecipients:toRecipients];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)selectDate:(id)datePicker {
    UIDatePicker *picker = (UIDatePicker *) datePicker;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *pickerDateString = [dateFormatter stringFromDate:picker.date];
    [[NSUserDefaults standardUserDefaults] setValue:pickerDateString forKey:@"FireDate"];
    [KNNotification registerNotificationWithDate:pickerDateString];
}

- (void)setIsDatePickerOn:(BOOL)isDatePickerOn {
    _isDatePickerOn = isDatePickerOn;
    self.datePicker.hidden = !isDatePickerOn;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"AboutCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    switch (indexPath.row) {
        case 0:   {
            cell.textLabel.text = @"提醒设置";
        }
            break;
        case 1:   {
            cell.textLabel.text = @"BMI介绍";
        }
            break;
        case 2:   {
            cell.textLabel.text = @"软件评分";
        }
            break;
        case 3:   {
            cell.textLabel.text = @"反馈意见";
        }
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setFont:[UIFont systemFontOfSize:_F(_Size14)]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            self.isDatePickerOn = !self.isDatePickerOn;
        }
            break;
        case 1: {
            KNAboutBMIView *vc = [[KNAboutBMIView alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=998079835&pageNumber=0&sortOrdering=2&type=Purple+Software"]];
        }
            break;
        case 3: {
            [self displayComposerSheet];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _F(40);
}

- (void)openSite {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kWebsite]];
}

- (void)openWeibo {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kWeibourl]];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter & Setter

- (KNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[KNTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"version_logo"]];
        _logoView.layer.cornerRadius = _F(33);
        _logoView.clipsToBounds = YES;
    }
    return _logoView;
}

- (UILabel *)verLab {
    if (!_verLab) {
        _verLab = [[UILabel alloc] init];
        [_verLab setText:[NSString stringWithFormat:@"版本号：%@",[KNDeviceInfo shortVersion]]];
        [_verLab setTextColor:[UIColor grayColor]];
        [_verLab setFont:[UIFont systemFontOfSize:_F(_Size12)]];
    }
    return _verLab;
}

- (UIButton *)webBtn {
    if (!_webBtn) {
        _webBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_webBtn setTitle:@"http://weibo.com/fuqiangiqwd" forState:UIControlStateNormal];
        [_webBtn.titleLabel setFont:[UIFont systemFontOfSize:_F(_Size12)]];
        [_webBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_webBtn addTarget:self action:@selector(openSite) forControlEvents:UIControlEventTouchUpInside];
    }
    return _webBtn;
}


- (UIButton *)weiboBtn {
    if (!_weiboBtn) {
        _weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weiboBtn setTitle:@"新浪微博：@fuqiangiqwd" forState:UIControlStateNormal];
        [_weiboBtn.titleLabel setFont:[UIFont systemFontOfSize:_F(_Size12)]];
        [_weiboBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_weiboBtn addTarget:self action:@selector(openWeibo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weiboBtn;
}

- (UIButton *)emailBtn {
    if (!_emailBtn) {
        _emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emailBtn setTitle:@"支持：fuqiangiqwd@163.com" forState:UIControlStateNormal];
        [_emailBtn.titleLabel setFont:[UIFont systemFontOfSize:_F(_Size12)]];
        [_emailBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _emailBtn;
}

- (UIDatePicker *)datePicker {
    if(!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

@end
