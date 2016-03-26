//
//  KNBMIHistoryCell.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNBMIHistoryCell.h"

@interface KNBMIHistoryCell()

@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *weightLab;
@property (nonatomic, strong) UILabel *indexLab;
@property (nonatomic, strong) UIView *avatarBack;

@end

@implementation KNBMIHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:CGRectMake(0, 0, _ScreenWidth, _F(55))];
        
        [self.contentView addSubview:self.avatarBack];
        [self.contentView addSubview:self.dateLab];
        [self.contentView addSubview:self.weightLab];
        [self.avatarBack addSubview:self.indexLab];
        
        [self.avatarBack setBackgroundColor:[UIColor grayColor]];
        
        [self.avatarBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(_F(10));
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(_F(50), _F(50)));
        }];
        [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarBack.mas_right).with.offset(_F(10));
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(_F(-10));
        }];
        [self.weightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarBack.mas_right).with.offset(_F(10));
            make.top.equalTo(self.contentView.mas_top).with.offset(_F(10));
        }];
        [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.avatarBack);
            make.size.mas_equalTo(CGSizeMake(_F(50), _F(50)));
        }];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)updateCell:(float)index date:(NSString *)dateStr weight:(float)weight {
    [self.indexLab setText:[NSString stringWithFormat:@"%.1f",index]];
    [self.dateLab setText:dateStr];
    [self.weightLab setText:[NSString stringWithFormat:@"%.1f千克",weight]];
    [self.avatarBack setBackgroundColor:[self updateAvatarBackByIndex:index]];
}

- (UIColor *)updateAvatarBackByIndex:(float)index {
    if (index > 18.5 && index <= 24) {
        return [UIColor greenColor];
    } else if(index <= 18.5) {
        return [UIColor brownColor];
    } else {
        return [UIColor redColor];
    }
}

#pragma mark - Getter & Setter

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_dateLab setFont:[UIFont systemFontOfSize:_Size12]];
        [_dateLab setTextColor:[UIColor blackColor]];
        [_dateLab setText:@"date"];
    }
    return _dateLab;
}

- (UILabel *)weightLab {
    if (!_weightLab) {
        _weightLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_weightLab setFont:[UIFont systemFontOfSize:_Size15]];
        [_weightLab setTextColor:[UIColor blackColor]];
        [_weightLab setText:@"weight"];
    }
    return _weightLab;
}

- (UILabel *)indexLab {
    if (!_indexLab) {
        _indexLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_indexLab setFont:[UIFont systemFontOfSize:_Size18]];
        [_indexLab setTextColor:[UIColor blackColor]];
        [_indexLab setTextAlignment:NSTextAlignmentCenter];
        [_indexLab setText:@"index"];
    }
    return _indexLab;
}

- (UIView *)avatarBack {
    if (!_avatarBack) {
        _avatarBack = [[UIView alloc] init];
    }
    return _avatarBack;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
