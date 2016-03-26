//  KNNotification.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNNotification.h"


@implementation KNNotification {

}
+ (void)registerNotificationWithDate:(NSString *)fireDate {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *date = [formatter dateFromString:fireDate];
        notification.fireDate = [date dateByAddingTimeInterval:60];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = @"来天天BMI记录体重吧！";
        notification.soundName = @"default";
        notification.repeatInterval = NSDayCalendarUnit;
        [notification setApplicationIconBadgeNumber:notification.applicationIconBadgeNumber++];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end