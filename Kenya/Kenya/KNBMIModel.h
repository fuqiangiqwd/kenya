//
//  KNBMIModel.h
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface KNBMIModel : NSObject

@property (nonatomic, assign) float height;
@property (nonatomic, assign) float weight;
@property (nonatomic, assign) float index;
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSString *desc;

@end
