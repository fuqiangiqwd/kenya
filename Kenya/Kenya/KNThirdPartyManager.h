//
//  KNThirdPartyManager.h
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface KNThirdPartyManager : NSObject

@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) NSArray *permissions;

+ (instancetype)manager;

+ (BOOL)isWxInstall;
+ (BOOL)isQQInstall;

- (BOOL)handleOpenURL:(NSURL *)url;

//微信分享，依次是文本、媒体、我们应用中的图片、网页链接，用第四个
- (void)wechatShare:(enum WXScene)scene text:(NSString *)text;
- (void)wechatShare:(enum WXScene)scene message:(WXMediaMessage *)msg;
- (void)wechatSharePic:(UIImage *)largeImage thumb:(UIImage *)thumbImage title:(NSString *)title description:(NSString *)description userName:(NSString *)userName imgUrl:(NSURL *)imageUrl scene:(enum WXScene)scene;
- (void)wechatShareUrl:(NSString *)url thumbImage:(UIImage *)thumbImage description:(NSString *)description userName:(NSString *)userName scene:(enum WXScene)scene;

//微博分享
- (void)weiboSharePicture:(UIImage *)image content:(NSString *)content picUrl:(NSURL *)picUrl;

//qq和qq空间分享
- (void)qqShare:(UIImage *)shareImg thumbImage:(UIImage *)thumbImage title:(NSString *)title description:(NSString *)description;
- (void)qzoneShare:(NSURL *)shareUrl thumbImage:(UIImage *)thumbImage title:(NSString *)title description:(NSString *)description;

@end
