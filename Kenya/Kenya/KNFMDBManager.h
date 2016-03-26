//
//  KNFMDBManager.h
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNFMDBManager : NSObject

+ (BOOL)createDataBase:(NSString *)path;
+ (BOOL)executeUpdate:(NSString *)sql file:(NSString *)path ;
+ (FMResultSet *)getQueryResult:(NSString *)sql file:(NSString *)path;

@end
