//
//  KNTableViewCell.m
//  Kenya
//
//  Created by wjdbr on 15/5/18.
//  Copyright (c) 2015年 wjdbr. All rights reserved.
//

#import "KNTableViewCell.h"

@implementation KNTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseID {
    return [NSString stringWithFormat:@"%@",[self class]];
}

@end
