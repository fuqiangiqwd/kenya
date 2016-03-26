//
//  KNTableView.m
//  Kenya
//
//  Created by wjdbr on 15/5/14.
//  Copyright (c) 2015年 wjdbr. All rights reserved.
//

#import "KNTableView.h"

@implementation KNTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [self setTableFooterView:v];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
