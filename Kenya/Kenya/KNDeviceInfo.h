//
//  KNDeviceInfo.h
//  Kenya
//
//  Created by wjdbr on 15/5/21.
//  Copyright (c) 2015年 wjdbr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNDeviceInfo : NSObject

+ (NSString *)DeviceUUID;
+ (NSString *)shortVersion;
+ (NSString *)buildVersion;
+ (long long)unixTimestamp;

@end
