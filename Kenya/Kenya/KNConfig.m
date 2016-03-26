//
//  KNConfig.m
//  Kenya
//
//  Created by wjdbr on 15/5/13.
//  Copyright (c) 2015年 wjdbr. All rights reserved.
//

#import "KNConfig.h"

@implementation KNConfig

//适配
+ (double)scaleInView {
    const double wid = _ScreenWidth;
    const double hid = _ScreenHeight;
    
    if (hid < 568) {
        return 0.95;
    } else if ( wid <= 320 ) {
        return 1.0;
    } else if (wid <= 375){
        return 1.06;
    } else {
        return 1.15;
    }
}

+ (NSString *)getBMITableSql {
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key AutoIncrement,height float(4),weight float(4),BMI float(4),description text,dateBMI varchar(20))",_BMITableName];
    return sql;
}

+ (NSString *)getDate {
    NSDate *dat = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:dat];
    return dateStr;
}

+ (UIColor *)themeColor {
    return [UIColor colorWithIntRed:21 green:121 blue:214 alpha:1.f];
}

+ (UIColor *)groupTableColor {
    return [UIColor colorWithIntRed:247 green:247 blue:247 alpha:1.f];
}

+ (UIColor *)grayColor {
    return [UIColor colorWithIntRed:200 green:200 blue:200 alpha:1.f];
}

+ (UIColor *)fontGrayColor {
    return [UIColor colorWithIntRed:93 green:93 blue:93 alpha:1.f];
}

@end
