//
//  KNChartViewController.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNChartViewController.h"
#import "KNThirdPartyManager.h"
#import "KNShareView.h"

@interface KNChartViewController()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PNLineChart *lineChart;
@property (nonatomic, strong) NSMutableArray *xLabels;
@property (nonatomic, strong) NSMutableArray *yData;
@property (nonatomic, assign) CGFloat chartWidth;

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UILabel *emptyLab;
@property (nonatomic, assign) BOOL isEmptyData;

@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation KNChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[KNConfig groupTableColor]];
    
    [self.view addSubview:self.titleView];
    self.navigationItem.titleView = self.titleView;
    
    [self.titleView addSubview:self.shareBtn];
    [self.titleView addSubview:self.cancelBtn];
    [self.titleView addSubview:self.titleLabel];

    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.centerY.equalTo(self.titleView).offset(_F(10));
        make.width.mas_equalTo(_F(50));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.centerY.equalTo(self.titleView).offset(_F(10));
        make.width.mas_equalTo(_F(50));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleView);
        make.centerY.equalTo(self.titleView).offset(_F(5));
    }];
    
    if (self.isEmptyData) {
        [self.emptyView addSubview:self.emptyLab];
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(_F(75));
            make.size.mas_equalTo(CGSizeMake(_ScreenWidth, _F(30)));
        }];
        [self.emptyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.emptyView);
        }];
    } else {
        [self.scrollView addSubview:self.lineChart];
        [self.view addSubview:self.self.scrollView];
        self.scrollView.contentSize = CGSizeMake(self.lineChart.bounds.size.width, 0);
    }
}

- (instancetype)initWithLabels:(NSMutableArray *)xLabels yData:(NSMutableArray *)yData {
    self = [super init];
    if (self) {
        self.xLabels = xLabels;
        self.yData = yData;
        self.chartWidth = 80 * xLabels.count + 100;
        self.isEmptyData = NO;
        if (xLabels.count == 0 || yData.count == 0) {
            self.isEmptyData = YES;
        }
    }
    return self;
}

- (void)shareGraph {
    if (self.isEmptyData) {
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progress.labelText = @"空记录不能分享";
        progress.mode = MBProgressHUDModeText;
        [progress hide:YES afterDelay:1.f];
        return;
    }
    
    UIImage *snap = [self getViewSnap:self.lineChart size:self.lineChart.bounds.size];
//    UIImageWriteToSavedPhotosAlbum(snap, nil, nil, nil);

    KNShareView *shareView = [[KNShareView alloc] initWithImage:snap];
    [shareView show];
}

- (void)closeView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)captureScreenWithBounds:(CGRect)rect {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)getViewSnap:(UIView *)view size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Getter & Setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _F(60), SCREEN_WIDTH, _F(280))];
        _scrollView.showsHorizontalScrollIndicator = FALSE;
        _scrollView.showsVerticalScrollIndicator = FALSE;
    }
    return _scrollView;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_shareBtn.titleLabel setFont:[UIFont systemFontOfSize:_F(_Size14)]];
        [_shareBtn addTarget:self action:@selector(shareGraph) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 //       [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:_F(_Size14)]];
        [_cancelBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _ScreenWidth, 64)];
        [_titleView setBackgroundColor:[KNConfig themeColor]];
    }
    return _titleView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setText:@"体重变化趋势"];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:_F(18)]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
    }
    return _titleLabel;
}

- (PNLineChart *)lineChart {
    if (!_lineChart) {
        if (_xLabels.count > 0 && _yData.count > 0) {
            _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, _F(0), self.chartWidth, _F(280))];
            [_lineChart setXLabels:self.xLabels];
            PNLineChartData *data01 = [PNLineChartData new];
            data01.color = PNFreshGreen;
            data01.itemCount = _lineChart.xLabels.count;
            data01.getData = ^(NSUInteger index) {
                CGFloat yValue = [self.yData[index] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };
            _lineChart.chartData = @[data01];
            
            _lineChart.showCoordinateAxis = YES;
            _lineChart.yUnit = @"千克";
            
            [_lineChart strokeChart];
            _lineChart.userInteractionEnabled = NO;
        }
    }
    return _lineChart;
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
    }
    return _emptyLab;
}

@end
