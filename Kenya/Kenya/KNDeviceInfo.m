//
//  KNDeviceInfo.m
//  Kenya
//
//  Created by wjdbr on 15/5/21.
//  Copyright (c) 2015年 wjdbr. All rights reserved.
//

#import "KNDeviceInfo.h"

@implementation KNDeviceInfo

static NSString * gq_uuid = nil;

+ (NSString *)DeviceUUID {
    return [[NSUUID UUID] UUIDString];
}

+ (NSString *)shortVersion {
    return (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)buildVersion {
    return (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)systemVersionName {
    return [[UIDevice currentDevice] systemName];
}

+ (long long)unixTimestamp {
    double time = [[NSDate date] timeIntervalSince1970];
    return time*1000;
}

@end
