//
//  KNThirdPartyManager.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNThirdPartyManager.h"

@interface KNThirdPartyManager()<WeiboSDKDelegate, WXApiDelegate, TencentSessionDelegate>

@end

@implementation KNThirdPartyManager

+ (instancetype)manager {
    static KNThirdPartyManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [WeiboSDK registerApp:kWeiboKey];
        [WeiboSDK enableDebugMode:NO];
        [WXApi registerApp:kWeixinKey withDescription:@"weixin"];
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQKey andDelegate:self];
        
        _permissions = @[kOPEN_PERMISSION_GET_USER_INFO,
                         kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                         kOPEN_PERMISSION_GET_INFO,
                         kOPEN_PERMISSION_ADD_TOPIC,
                         kOPEN_PERMISSION_UPLOAD_PIC,
                         ];
    }
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self] ||
    [WXApi handleOpenURL:url delegate:self] ||
    [TencentOAuth HandleOpenURL:url];
}

#pragma mark - 判断qq和微信是否安装

+ (BOOL)isWxInstall {
    return [WXApi isWXAppInstalled];
}

+ (BOOL)isQQInstall {
    return [QQApi isQQInstalled];
}

#pragma mark - 微信分享
- (void)wechatShare:(enum WXScene)scene text:(NSString *)text {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = scene;
    
    [WXApi sendReq: req];
}

- (void)wechatShare:(enum WXScene)scene message:(WXMediaMessage *)msg {
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = msg;
    req.scene = scene;
    
    if(![WXApi sendReq:req]) {
        NSLog(@"error");
    }
}

- (void)wechatSharePic:(UIImage *)largeImage thumb:(UIImage *)thumbImage title:(NSString *)title description:(NSString *)description userName:(NSString *)userName imgUrl:(NSURL *)imageUrl scene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"%@:%@",title,userName];
    message.description = description;
    [message setThumbImage:thumbImage];
    
    if (largeImage) {
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = UIImageJPEGRepresentation(largeImage, 1);
        message.mediaObject = ext;
    } else {
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = [imageUrl absoluteString];
        message.mediaObject = ext;
    }
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    if(![WXApi sendReq:req]) {
        NSLog(@"error");
    }
}

- (void)wechatShareUrl:(NSString *)url thumbImage:(UIImage *)thumbImage description:(NSString *)description userName:(NSString *)userName scene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = userName;
    message.description = description;
    
    [message setThumbImage:thumbImage];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    if(![WXApi sendReq:req]) {
        NSLog(@"error");
    }
}

#pragma mark - 微博分享
- (void)weiboSharePicture:(UIImage *)image content:(NSString *)content picUrl:(NSURL *)picUrl {
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare:image content:content picUrl:picUrl] authInfo:authRequest access_token:kWeiboKey];
    request.userInfo = @{@"ShareMessageFrom": @"天天BMI",
                         };
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare:(UIImage *)image1 content:(NSString *)content picUrl:(NSURL *)picUrl {
    WBMessageObject *message = [WBMessageObject message];
    WBImageObject *image = [WBImageObject object];
    if (image1) {
        image.imageData = UIImageJPEGRepresentation(image1, 1);
    } else {
        image.imageData = [NSData dataWithContentsOfURL:picUrl];
    }
    message.imageObject = image;
    message.text = content;
    return message;
}

#pragma mark - qq分享
- (void)qqShare:(UIImage *)shareImg thumbImage:(UIImage *)thumbImage title:(NSString *)title description:(NSString *)description {
    QQApiImageObject *obj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(shareImg) previewImageData:UIImagePNGRepresentation(thumbImage) title:title description:description];
    [QQApiInterface sendReq:[SendMessageToQQReq reqWithContent:obj]];
}


#pragma mark - qq空间分享
- (void)qzoneShare:(NSURL *)shareUrl thumbImage:(UIImage *)thumbImage title:(NSString *)title description:(NSString *)description {
    QQApiNewsObject *ob = [QQApiNewsObject objectWithURL:shareUrl title:title description:description previewImageData:UIImagePNGRepresentation(thumbImage)];
    [QQApiInterface SendReqToQZone:[SendMessageToQQReq reqWithContent:ob]];
}


#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {

}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
}

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq*)req {
    
}

- (void)onResp:(BaseResp*)resp {

}

#pragma mark - TencentSessionDelegate

- (void)tencentDidLogin {

}

- (void)tencentDidLogout {
    
}

- (void)tencentDidNotNetWork {

}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}
@end
