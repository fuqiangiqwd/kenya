//
//  KNNavigationController.m
//  Kenya
//
//  Created by wjdbr on 15/5/14.
//  Copyright (c) 2015年 wjdbr. All rights reserved.
//

#import "KNNavigationController.h"

@interface KNNavigationController ()

@end

@implementation KNNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype) initWithTitle:(NSString *)title rootView:(KNViewController *)rootView {
    self = [super initWithRootViewController:rootView];
    [self setTitle:title];
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
