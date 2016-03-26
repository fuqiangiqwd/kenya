//
//  KNAboutBMIView.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNAboutBMIView.h"

@interface KNAboutBMIView ()

@property (nonatomic, strong) UILabel *bmiLab;
@property (nonatomic, strong) UILabel *bmiFormulaLab;
@property (nonatomic, strong) UILabel *bmiExampleLab;

@end


@implementation KNAboutBMIView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"BMI介绍";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.bmiLab];
    [self.view addSubview:self.bmiFormulaLab];
    [self.view addSubview:self.bmiExampleLab];
    
    [self.bmiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(_F(75));
        make.width.mas_equalTo(_ScreenWidth - _F(20));
    }];
    [self.bmiFormulaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bmiLab.mas_bottom).with.offset(_F(10));
    }];
    [self.bmiExampleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bmiFormulaLab.mas_bottom).with.offset(_F(5));
    }];
}


#pragma mark - Getter & Setter

- (UILabel *)bmiLab {
    if (!_bmiLab) {
        _bmiLab = [[UILabel alloc] init];
        [_bmiLab setFont:[UIFont systemFontOfSize:_F(_Size12)]];
        [_bmiLab setTextColor:[UIColor blackColor]];
        [_bmiLab setText:@"BMI指数（身体质量指数，简称体质指数又称体重指数，英文Body Mass Index，简称BMI），是用体重公斤数除以身高平方得出的数字，是目前国际上常用的人体胖瘦程度以及是否健康的一个标准。主要用于统计用途，当我们需要比较及分析一个人的体重对于不同高度的人所带来的健康影响时，BMI值是一个中立而可靠的指标。"];
        _bmiLab.numberOfLines = 0;
    }
    return _bmiLab;
}

- (UILabel *)bmiFormulaLab {
    if (!_bmiFormulaLab) {
        _bmiFormulaLab = [[UILabel alloc] init];
        [_bmiFormulaLab setFont:[UIFont systemFontOfSize:_F(_Size16)]];
        [_bmiFormulaLab setTextColor:[UIColor blackColor]];
        [_bmiFormulaLab setText:@"BMI=体重(kg)÷身高(m)^2"];
//        [_bmiFormulaLab setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _bmiFormulaLab;
}

- (UILabel *)bmiExampleLab {
    if (!_bmiExampleLab) {
        _bmiExampleLab = [[UILabel alloc] init];
        [_bmiExampleLab setFont:[UIFont systemFontOfSize:_F(_Size16)]];
        [_bmiExampleLab setTextColor:[UIColor blackColor]];
        [_bmiExampleLab setText:@"例：70kg÷(1.75*1.75)=22.86"];
    }
    return _bmiExampleLab;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
