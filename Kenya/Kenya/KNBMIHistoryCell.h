//
//  KNBMIHistoryCell.h
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNTableViewCell.h"

@interface KNBMIHistoryCell : KNTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateCell:(float)index date:(NSString *)dateStr weight:(float)weight;

@end
