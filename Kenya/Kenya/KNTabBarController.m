//
//  KNTabBarController.m
//  Kenya
//
//  Created by wjdbr on 15/5/14.
//  Copyright (c) 2015年 wjdbr. All rights reserved.
//

#import "KNTabBarController.h"

@interface KNTabBarController ()

@end

@implementation KNTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype) initWithViewControllers:(NSArray *)views {
    self = [super initWithNibName:nil bundle:nil];
    self.viewControllers = views;
    return self;
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
