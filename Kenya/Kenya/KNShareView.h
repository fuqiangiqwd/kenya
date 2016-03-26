//
//  KNShareView.h
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface KNShareView : UIView

@property (nonatomic, strong) UIImage *thumbImg;
@property (nonatomic, strong) UIImage *shareImg;

- (instancetype)initWithImage:(UIImage *)image;

- (void)show;
- (void)dismiss;

@end
