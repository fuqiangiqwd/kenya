//
//  KNMainViewController.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNMainViewController.h"
#import "KNBMIHistory.h"
#import "KNBMIViewController.h"
#import "KNTabBarController.h"
#import "KNNavigationController.h"
#import "KNAboutViewController.h"
#import "KNNotification.h"
#import "KNNotification.h"

@interface KNMainViewController ()

@end

@implementation KNMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *fireString = [[NSUserDefaults standardUserDefaults] valueForKey:@"FireDate"];
    if(fireString.length == 0) {
        NSDate *date = [NSDate new];
        fireString = [self stringFromDate:date];
        [[NSUserDefaults standardUserDefaults] setValue:fireString forKey:@"FireDate"];
        [KNNotification registerNotificationWithDate:fireString];
    }
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    KNNavigationController *staVC = [self addChildWithType:0];
    KNNavigationController *bmiVC = [self addChildWithType:1];
    KNNavigationController *aboVC = [self addChildWithType:2];
    self = [super initWithViewControllers:@[staVC,bmiVC,aboVC]];
    return self;
}

- (KNNavigationController *) addChildWithType:(NSInteger)type {
    NSString *title = nil;
    NSString *normalImage = nil;
//    NSString *selectedImage = nil;
    KNViewController *rootVC = nil;
    switch (type) {
        case 0: {
            rootVC = [[KNBMIViewController alloc] init];
            title = @"体型";
            normalImage = @"tabbar_home";
//            selectedImage = nil;
        }
            break;
        case 1: {
            rootVC = [[KNBMIHistory alloc] init];
            title = @"记录";
            normalImage = @"tabbar_history";
//            selectedImage = nil;
        }
            break;
        case 2: {
            rootVC = [[KNAboutViewController alloc] init];
            title = @"关于";
            normalImage = @"tabbar_about";
//            selectedImage = nil;
        }
            break;
        default:
            break;
    }
    UIImage *normalImg = [UIImage imageNamed:normalImage];
    UIImage *selectedImg = [UIImage imageNamed:normalImage];
    rootVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImg selectedImage:selectedImg];
    KNNavigationController *nav = [[KNNavigationController alloc] initWithTitle:title rootView:rootVC];
    [nav.navigationBar setBarTintColor:[KNConfig themeColor]];
    return nav;
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
