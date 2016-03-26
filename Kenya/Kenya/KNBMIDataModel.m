//
//  KNBMIDataModel.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//


#import "KNBMIDataModel.h"
#import "KNFMDBManager.h"

@implementation KNBMIDataModel

+ (NSString *)getBMIRange:(float)index {
    NSString *strRange = nil;
    if (index < 18.5) {
        strRange = @"过轻";
    } else if(index >= 18.5 && index < 24) {
        strRange = @"正常";
    } else if(index >= 24 && index < 27) {
        strRange = @"过重";
    } else if(index >= 27 && index < 30) {
        strRange = @"轻度肥胖";
    } else if(index >= 30   && index < 35) {
        strRange = @"中度肥胖";
    } else if(index >= 35) {
        strRange = @"过度肥胖";
    }
    return strRange;
}

+ (float)getBMIIndex:(float)height weight:(float)weight {
    float index = weight / (height * height) * 10000;
    return index;
}

- (NSMutableArray *)getBMIHistory {
    [KNFMDBManager executeUpdate:_BMICreateTableSql file:_BMIDataBase];
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by dateBMI desc",_BMITableName];
    FMResultSet *result = [KNFMDBManager getQueryResult:sql file:_BMIDataBase];
    while ([result next]) {
        KNBMIModel *mod = [[KNBMIModel alloc] init];
        mod.dateStr = [result stringForColumn:@"dateBMI"];
        mod.index = [[result stringForColumn:@"BMI"] floatValue];
        mod.height = [[result stringForColumn:@"height"] floatValue];
        mod.weight = [[result stringForColumn:@"weight"] floatValue];
        mod.desc = [result stringForColumn:@"description"];
        [array addObject:mod];
    }
    [result close];
    return array;
}

- (NSMutableDictionary *)getBMIHistoryDict {
    [KNFMDBManager executeUpdate:_BMICreateTableSql file:_BMIDataBase];
    NSDictionary *dictMonth = [self getDistinctMonths];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *monthItem in dictMonth.keyEnumerator) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where substr(datebmi,0,7)='%@' order by dateBMI desc",_BMITableName,monthItem];
        FMResultSet *result = [KNFMDBManager getQueryResult:sql file:_BMIDataBase];
        while ([result next]) {
            KNBMIModel *mod = [[KNBMIModel alloc] init];
            mod.dateStr = [result stringForColumn:@"dateBMI"];
            mod.index = [[result stringForColumn:@"BMI"] floatValue];
            mod.height = [[result stringForColumn:@"height"] floatValue];
            mod.weight = [[result stringForColumn:@"weight"] floatValue];
            mod.desc = [result stringForColumn:@"description"];
            [array addObject:mod];
        }
        [result close];
        [dict setObject:array forKey:monthItem];
    }
    self.dictionary = dict;
    return dict;
}

- (BOOL)insertBMIRecord:(KNBMIModel *)model {
    [KNFMDBManager executeUpdate:_BMICreateTableSql file:_BMIDataBase];
    NSString *sql = [NSString stringWithFormat:@"insert into %@ values(null,%f,%f,%f,'%@','%@')",_BMITableName,model.height,model.weight,model.index,model.desc,model.dateStr];
    return [KNFMDBManager executeUpdate:sql file:_BMIDataBase];
}

- (BOOL)deleteBMIRecord:(KNBMIModel *)model {
    [KNFMDBManager executeUpdate:_BMICreateTableSql file:_BMIDataBase];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where dateBMI='%@'",_BMITableName,model.dateStr];
    return [KNFMDBManager executeUpdate:sql file:_BMIDataBase];
}

- (NSMutableDictionary *)getDistinctMonths {
    [KNFMDBManager executeUpdate:_BMICreateTableSql file:_BMIDataBase];
    NSString *sql = [NSString stringWithFormat:@"select distinct substr(dateBMI,0,7) orderBMI,count(*) sum from %@ group by orderBMI order by dateBMI desc",_BMITableName];
    FMResultSet *resultSet = [KNFMDBManager getQueryResult:sql file:_BMIDataBase];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    while ([resultSet next]) {
        [dict setObject:[resultSet stringForColumn:@"sum"] forKey:[resultSet stringForColumn:@"orderBMI"]];
    }
    [resultSet close];
    return dict;
}

- (NSMutableArray *)getMonthRecord:(NSString *)month {
    [KNFMDBManager executeUpdate:_BMICreateTableSql file:_BMIDataBase];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where substr(dateBMI,0,7)='%@' order by dateBMI desc",_BMITableName,month];
    FMResultSet *result = [KNFMDBManager getQueryResult:sql file:_BMIDataBase];
    NSMutableArray *array = [NSMutableArray array];
    while ([result next]) {
        KNBMIModel *mod = [[KNBMIModel alloc] init];
        mod.dateStr = [result stringForColumn:@"dateBMI"];
        mod.index = [[result stringForColumn:@"BMI"] floatValue];
        mod.height = [[result stringForColumn:@"height"] floatValue];
        mod.weight = [[result stringForColumn:@"weight"] floatValue];
        mod.desc = [result stringForColumn:@"description"];
        [array addObject:mod];
    }
    [result close];
    return array;
}

@end
