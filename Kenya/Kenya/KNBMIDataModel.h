//
//  KNBMIDataModel.h
//  Kenya
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "KNBMIModel.h"

@interface KNBMIDataModel : NSObject

@property (nonatomic, strong) KNBMIModel *model;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableDictionary *dictionary;

+ (NSString *)getBMIRange:(float)index;
+ (float)getBMIIndex:(float)height weight:(float)weight;

- (NSMutableArray *)getBMIHistory;
- (BOOL)insertBMIRecord:(KNBMIModel *)model;
- (BOOL)deleteBMIRecord:(KNBMIModel *)model;
- (NSMutableDictionary *)getDistinctMonths;
- (NSMutableArray *)getMonthRecord:(NSString *)month;
- (NSMutableDictionary *)getBMIHistoryDict;

@end
