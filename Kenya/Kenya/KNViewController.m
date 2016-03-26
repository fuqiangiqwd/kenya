//
//  KNViewController.m
//  Kenya
//
//  Created by wjdbr on 15/5/14.
//  Copyright (c) 2015年 wjdbr. All rights reserved.
//

#import "KNViewController.h"

@interface KNViewController ()

@end

@implementation KNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _autoCloseKeyboard = NO;
}

- (void)setAutoCloseKeyboard:(BOOL)autoCloseKeyboard {
    _autoCloseKeyboard = autoCloseKeyboard;
    if (_autoCloseKeyboard) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
        [self.view addGestureRecognizer:tap];
        [self closeKeyboard];
    }
}

- (void)closeKeyboard {
    for (NSObject *v in self.view.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            [((UITextField *)v) resignFirstResponder];
        }
    }
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
 
- (void)didReceiveMemoryWarning {
[super didReceiveMemoryWarning];
// Dispose of any resources that can be recreated.
}
*/

@end
