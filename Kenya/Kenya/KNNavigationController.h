//
//  KNNavigationController.h
//  Kenya
//
//  Created by wjdbr on 15/5/14.
//  Copyright (c) 2015年 wjdbr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNViewController.h"

@interface KNNavigationController : UINavigationController

- (instancetype) initWithTitle:(NSString *)title rootView:(KNViewController *)rootView;

@end
