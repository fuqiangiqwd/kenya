//
//  KNBMIViewController.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNBMIViewController.h"
#import "KNBMIHistory.h"
#import "KNFMDBManager.h"
#import "KNBMIModel.h"
#import "KNBMIDataModel.h"

#define NUMBERS @"0123456789.\n"

@interface KNBMIViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *heightText;
@property (nonatomic, strong) UITextField *weightText;
@property (nonatomic, strong) UILabel *kgLab;
@property (nonatomic, strong) UILabel *cmLab;
@property (nonatomic, strong) UIButton *calBtn;
@property (nonatomic, strong) UILabel *rangeLab;
@property (nonatomic, strong) UILabel *indexLab;
@property (nonatomic, strong) UIImageView *heightImg;
@property (nonatomic, strong) UIImageView *weightImg;

@end

@implementation KNBMIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"体型";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.autoCloseKeyboard = YES;
    
    [self.view addSubview:self.heightText];
    [self.view addSubview:self.weightText];
    [self.view addSubview:self.kgLab];
    [self.view addSubview:self.cmLab];
    [self.view addSubview:self.calBtn];
    [self.view addSubview:self.indexLab];
    [self.view addSubview:self.rangeLab];
    [self.view addSubview:self.weightImg];
    [self.view addSubview:self.heightImg];
    
    [self.heightText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(_F(150));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(_F(200));
        make.height.mas_equalTo(_F(32));
    }];
    [self.cmLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.heightText.mas_right);
        make.centerY.equalTo(self.heightText);
    }];

    [self.weightText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heightText.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(_F(200));
        make.height.mas_equalTo(_F(32));
    }];
    [self.kgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.weightText.mas_right);
        make.centerY.equalTo(self.weightText);
    }];
    
    [self.calBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weightText.mas_bottom).with.offset(_F(20));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(_F(80), _F(30)));
    }];
    
    [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.calBtn.mas_bottom).with.offset(_F(20));
    }];
    [self.rangeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.indexLab.mas_bottom).with.offset(_F(10));
    }];

    self.heightText.leftView = self.heightImg;
    self.heightText.leftViewMode = UITextFieldViewModeAlways;
    self.weightText.leftView = self.weightImg;
    self.weightText.leftViewMode = UITextFieldViewModeAlways;
    self.heightText.rightView = self.cmLab;
    self.heightText.rightViewMode = UITextFieldViewModeAlways;
    self.weightText.rightView = self.kgLab;
    self.weightText.rightViewMode = UITextFieldViewModeAlways;
    
    [self getLastHeight];
}

- (void)getLastHeight {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"LastHeight"]) {
        self.heightText.text = @"";
        [self.heightText becomeFirstResponder];
    } else {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastHeight"];
        self.heightText.text = str;
        [self.weightText becomeFirstResponder];
    }
}

- (void)setLastHeight {
    [[NSUserDefaults standardUserDefaults] setObject:self.heightText.text forKey:@"LastHeight"];
}

- (void)calculateBMI {
    self.autoCloseKeyboard = YES;
    
    NSString *strHeight = self.heightText.text;
    NSString *strWeight = self.weightText.text;
    BOOL flag = YES;
    if (![self isPureFloat:strHeight]) {
        [self shakeAnimation:self.heightText];
        flag = NO;
    }
    if (![self isPureFloat:strWeight]) {
        [self shakeAnimation:self.weightText];
        flag = NO;
    }
    if (!flag) {
        return;
    }
    float height = [strHeight floatValue];
    float weight = [strWeight floatValue];
    float index = [KNBMIDataModel getBMIIndex:height weight:weight];
    if (![self isPureFloat:[NSString stringWithFormat:@"%f",index]]) {
        return;
    }
    
    NSString *strdesc = [KNBMIDataModel getBMIRange:index];
    [self.indexLab setText:[NSString stringWithFormat:@"%f",index]];
    [self.rangeLab setText:[NSString stringWithFormat:@"%@,18.5-25为正常",strdesc]];
    [self setLastHeight];
    
    KNBMIModel *model = [[KNBMIModel alloc] init];
    model.height = height;
    model.weight = weight;
    model.index = index;
    model.desc = strdesc;
    model.dateStr = [KNConfig getDate];
    [[[KNBMIDataModel alloc] init] insertBMIRecord:model];
}

- (void)shakeAnimation:(UIView *)view {
    CGPoint center = view.center;
    [UIView animateWithDuration:.1f animations:^{
        view.center = CGPointMake(center.x - 20, view.center.y);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1f animations:^{
            view.center = CGPointMake(center.x + 20, view.center.y);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.2f animations:^{
                view.center = CGPointMake(center.x - 20, view.center.y);
            } completion:^(BOOL finished) {
                view.center = center;
            }];
        }];
    }];
}

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == self.heightText || textField == self.weightText)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            return NO;
        }
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
}

#pragma mark - Getter & Setter

- (UITextField *)heightText {
    if (!_heightText) {
        _heightText = [[UITextField alloc] initWithFrame:CGRectZero];
        _heightText.placeholder = @"身高";
        [_heightText setFont:[UIFont systemFontOfSize:_F(_Size14)]];
        _heightText.keyboardType = UIKeyboardTypeDecimalPad;
        _heightText.delegate = self;
        _heightText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _heightText.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _heightText;
}

- (UITextField *)weightText {
    if (!_weightText) {
        _weightText = [[UITextField alloc] initWithFrame:CGRectZero];
        _weightText.placeholder = @"体重";
        [_weightText setFont:[UIFont systemFontOfSize:_F(_Size14)]];
        _weightText.keyboardType = UIKeyboardTypeDecimalPad;
        _weightText.delegate = self;
        _weightText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _weightText.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _weightText;
}

- (UIImageView *)heightImg {
    if (!_heightImg) {
        _heightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"height"]];
    }
    return _heightImg;
}

- (UIImageView *)weightImg {
    if (!_weightImg) {
        _weightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weight"]];
    }
    return _weightImg;
}

- (UILabel *)kgLab {
    if (!_kgLab) {
        _kgLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_kgLab setFont:[UIFont systemFontOfSize:_F(_Size11)]];
        [_kgLab setTextColor:[KNConfig grayColor]];
        [_kgLab setText:@"千克"];
    }
    return _kgLab;
}

- (UILabel *)cmLab {
    if (!_cmLab) {
        _cmLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_cmLab setFont:[UIFont systemFontOfSize:_F(_Size11)]];
        [_cmLab setTextColor:[KNConfig grayColor]];
        [_cmLab setText:@"厘米"];
    }
    return _cmLab;
}

- (UIButton *)calBtn {
    if (!_calBtn) {
        _calBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_calBtn setTitle:@"计算" forState:UIControlStateNormal];
        [_calBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_calBtn.titleLabel setFont:[UIFont systemFontOfSize:_Size16]];
        [_calBtn setBackgroundColor:[KNConfig themeColor]];
        [_calBtn.layer setCornerRadius:4.f];
        [_calBtn.layer setMasksToBounds:YES];
        [_calBtn addTarget:self action:@selector(calculateBMI) forControlEvents:UIControlEventTouchUpInside];
    }
    return _calBtn;
}

- (UILabel *)rangeLab {
    if (!_rangeLab) {
        _rangeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_rangeLab setFont:[UIFont systemFontOfSize:_Size16]];
        [_rangeLab setTextColor:[UIColor blackColor]];
    }
    return _rangeLab;
}

- (UILabel *)indexLab {
    if (!_indexLab) {
        _indexLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_indexLab setFont:[UIFont systemFontOfSize:_Size18]];
        [_indexLab setTextColor:[UIColor blackColor]];
    }
    return _indexLab;
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
