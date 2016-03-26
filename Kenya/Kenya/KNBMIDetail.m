//
//  KNBMIDetail.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNBMIDetail.h"

@interface KNBMIDetail ()

@property (nonatomic, strong) UILabel *heightLab;
@property (nonatomic, strong) UILabel *weightLab;
@property (nonatomic, strong) UILabel *indexLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, strong) KNBMIModel *model;

@end

@implementation KNBMIDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.heightLab];
    [self.view addSubview:self.weightLab];
    [self.view addSubview:self.indexLab];
    [self.view addSubview:self.descLab];
    [self.view addSubview:self.dateLab];
    
    [self.heightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(_F(80));
    }];
    [self.weightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.heightLab.mas_bottom).with.offset(_F(10));
    }];
    [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.weightLab.mas_bottom).with.offset(_F(10));
    }];
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.indexLab.mas_bottom).with.offset(_F(10));
    }];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.descLab.mas_bottom).with.offset(_F(10));
    }];
    
}

- (instancetype)initWithBMIModel:(KNBMIModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

#pragma mark - Getter & Setter

- (UILabel *)heightLab {
    if (!_heightLab) {
        _heightLab = [[UILabel alloc] init];
        [_heightLab setText:[NSString stringWithFormat:@"身高:%.1f cm",self.model.height]];
        [_heightLab setTextColor:[UIColor blackColor]];
        [_heightLab setFont:[UIFont systemFontOfSize:_F(_Size16)]];
    }
    return _heightLab;
}

- (UILabel *)weightLab {
    if (!_weightLab) {
        _weightLab = [[UILabel alloc] init];
        [_weightLab setText:[NSString stringWithFormat:@"体重:%.1f kg",self.model.weight]];
        [_weightLab setTextColor:[UIColor blackColor]];
        [_weightLab setFont:[UIFont systemFontOfSize:_F(_Size16)]];
    }
    return _weightLab;
}

- (UILabel *)indexLab {
    if (!_indexLab) {
        _indexLab = [[UILabel alloc] init];
        [_indexLab setText:[NSString stringWithFormat:@"指数:%.1f",self.model.index]];
        [_indexLab setTextColor:[UIColor blackColor]];
        [_indexLab setFont:[UIFont systemFontOfSize:_F(_Size16)]];
    }
    return _indexLab;
}

- (UILabel *)descLab {
    if (!_descLab) {
        _descLab = [[UILabel alloc] init];
        [_descLab setText:[NSString stringWithFormat:@"描述:%@",self.model.desc]];
        [_descLab setTextColor:[UIColor blackColor]];
        [_descLab setFont:[UIFont systemFontOfSize:_F(_Size16)]];
    }
    return _descLab;
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        [_dateLab setText:[NSString stringWithFormat:@"时间:%@",self.model.dateStr]];
        [_dateLab setTextColor:[UIColor blackColor]];
        [_dateLab setFont:[UIFont systemFontOfSize:_F(_Size16)]];
    }
    return _dateLab;
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
