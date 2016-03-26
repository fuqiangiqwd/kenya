//
//  KNShareView.m
//  Kenya
//
//  Created by fuqiangiqwd.
//  Copyright (c) 2016年 fuqiangiqwd. All rights reserved.
//

#import "KNShareView.h"
#import "KNThirdPartyManager.h"
#import "KNViewController.h"

#define ScreenRect [UIScreen mainScreen].bounds

@interface KNPopupShareStruct : NSObject

@property (nonatomic, assign) int tag;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;

- (instancetype)initWithNum:(int)num title:(NSString *)title image:(NSString *)image;

@end

@implementation KNPopupShareStruct

- (instancetype)initWithNum:(int)num title:(NSString *)title image:(NSString *)image {
    self = [super init];
    self.tag = num;
    self.image = image;
    self.name = title;
    return self;
}

@end

@interface KNShareView()

@property (nonatomic, strong) NSNumber *time;

@property (nonatomic, strong) UIView *dimBackground;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) KNThirdPartyManager *manager;

@end

@implementation KNShareView

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _thumbImg = image;
        _shareImg = image;
        _dimBackground = [[UIView alloc] initWithFrame:ScreenRect];
        _dimBackground.backgroundColor = [UIColor clearColor];
        [self setBackgroundColor:[UIColor whiteColor]];
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_dimBackground addGestureRecognizer:gr];
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        
        CGFloat PopHeight = _F(154);
        [self setFrame:CGRectMake(0, ScreenRect.size.height, ScreenRect.size.width, PopHeight)];
        
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [shareLabel setText:@"分享给"];
        [shareLabel setTextColor:[KNConfig fontGrayColor]];
        [shareLabel setFont:[UIFont systemFontOfSize:_Size14]];
        [self addSubview:shareLabel];
        [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(_F(11));
            make.left.equalTo(self).with.offset(_F(10));
        }];
        
        NSMutableArray *shareBtnArray = [NSMutableArray array];
        
        [shareBtnArray addObject:[[KNPopupShareStruct alloc] initWithNum:102 title:@"微信好友" image:@"feed_share_floatinglayer_wechat"]];
        [shareBtnArray addObject:[[KNPopupShareStruct alloc] initWithNum:103 title:@"朋友圈" image:@"feed_share_floatinglayer_friendsquan"]];
        
        [shareBtnArray addObject:[[KNPopupShareStruct alloc] initWithNum:104 title:@"微博" image:@"feed_share_floatinglayer_weibo"]];
        
        [shareBtnArray addObject:[[KNPopupShareStruct alloc] initWithNum:105 title:@"QQ空间" image:@"feed_share_floatinglayer_qzone"]];
        [shareBtnArray addObject:[[KNPopupShareStruct alloc] initWithNum:106 title:@"QQ好友" image:@"feed_share_floatinglayer_qq"]];
        UIView *firstView = [self geneViewWithObjects:shareBtnArray];
        CGFloat firstWidth = _F(15*6+30+45*(shareBtnArray.count));
        [firstView setFrame:CGRectMake(0, 0, firstWidth, _F(70))];
        UIScrollView *firstScrll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width,_F(70))];
        [firstScrll addSubview:firstView];
        firstScrll.showsHorizontalScrollIndicator = NO;
        [firstScrll setContentSize:firstView.bounds.size];
        [self addSubview:firstScrll];
        [firstScrll setFrame:CGRectMake(0, _F(35), ScreenRect.size.width, _F(70))];

        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[KNConfig fontGrayColor] forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:_Size16]];
        [cancelBtn setBackgroundColor:[KNConfig groupTableColor]];
        [cancelBtn setFrame:CGRectMake(0, PopHeight - _F(48), ScreenRect.size.width, _F(48))];
        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn.layer setBorderColor:[KNConfig fontGrayColor].CGColor];
        [self addSubview:cancelBtn];

        _manager = [KNThirdPartyManager manager];
    }
    return self;
}

//根据按钮名称和图片地址返回view
- (UIView *)geneViewWithObjects:(NSMutableArray *)objArray {
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectZero];
    for (int i = 0;i < objArray.count;i++) {
        KNPopupShareStruct *st = [objArray objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:st.image] forState:UIControlStateNormal];
        [btn setBounds:CGRectMake(0, 0, _F(45), _F(45))];
        [btn setTag:st.tag];
        [btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [firstView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstView.mas_left).with.offset(_F(10 + (45 + 15) * i));
            make.top.equalTo(firstView);
        }];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setText:st.name];
        [label setTextColor:[KNConfig fontGrayColor]];
        [label setFont:[UIFont systemFontOfSize:_Size13]];
        [firstView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(btn.mas_bottom).with.offset(_F(5));
        }];
    }
    return firstView;
}

- (void)shareBtnPress:(UIButton *)sender {
//    [self dismiss];
    NSString *str = nil;
    
    switch (sender.tag) {
        case 102:     {//微信好友
            if (![KNThirdPartyManager isWxInstall]) {
                [self showMessage:@"尚未安装微信"];
                return;
            }
            str = [NSString stringWithFormat:@"快来看看我最近的身材变化曲线，我已瘦成一道闪电!"];
            [_manager wechatSharePic:_shareImg thumb:_thumbImg title:str description:str userName:nil imgUrl:nil scene:WXSceneSession];
        }
            break;
        case 103:     {//朋友圈
            if (![KNThirdPartyManager isWxInstall]) {
                [self showMessage:@"尚未安装微信"];
                return;
            }
            str = [NSString stringWithFormat:@"快来看看我最近的身材变化曲线，我已瘦成一道闪电!"];
            [_manager wechatSharePic:_shareImg thumb:_thumbImg title:str description:str userName:nil imgUrl:nil scene:WXSceneTimeline];
        }
            break;
        case 104:     {//微博
            str = [NSString stringWithFormat:@"快来看看我最近的身材变化曲线，我已瘦成一道闪电!下载：%@",[self shareUrl]];
            [_manager weiboSharePicture:_shareImg content:str picUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
        }
            break;
        case 105:     {//qq空间
            if (![KNThirdPartyManager isQQInstall]) {
                [self showMessage:@"尚未安装QQ"];
                return;
            }
            str = [NSString stringWithFormat:@"快来看看我最近的身材变化曲线，我已瘦成一道闪电!"];
            [_manager qzoneShare:[NSURL URLWithString:[self shareUrl]] thumbImage:_thumbImg title:str description:str];
        }
            break;
        case 106:     {//qq好友
            if (![KNThirdPartyManager isQQInstall]) {
                [self showMessage:@"尚未安装QQ"];
                return;
            }
            str = [NSString stringWithFormat:@"快来看看我最近的身材变化曲线，我已瘦成一道闪电!"];
            [_manager qqShare:_shareImg thumbImage:_thumbImg title:str description:str];
        }
            break;
        default:
            break;
    }
    [self dismiss];

}

- (NSString *)shareUrl {
    return [NSString stringWithFormat:@"http://weibo.com/fuqiangiqwd"];
}

- (void)showMessage:(NSString *)message {
    MBProgressHUD *showMessage = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    showMessage.labelText = message;
    showMessage.mode = MBProgressHUDModeText;
    [showMessage hide:YES afterDelay:1.f];
}

#pragma mark - 显示与隐藏

- (void)show {
    self.window = [[UIWindow alloc] initWithFrame:ScreenRect];
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = [KNViewController new];
    self.window.rootViewController.view.backgroundColor = [UIColor clearColor];
    [self.window.rootViewController.view addSubview:self.dimBackground];
    [self.window.rootViewController.view addSubview:self];
    self.window.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.dimBackground.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4f];
        self.frame = CGRectMake(0, ScreenRect.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.dimBackground.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, ScreenRect.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.window = nil;
        
    }];
}

#pragma mark - 画分割线
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, 218/255.0, 218/255.0, 218/255.0, 1.0);
    [self drawFrom:0 to:ScreenRect.size.width context:context];
}

- (void)drawFrom:(CGFloat)fromP to:(CGFloat)toP context:(CGContextRef)context {
    if (fromP == toP) {
        return;
    }
    CGFloat plainY = _F(106);
    [self drawLineFrom:CGPointMake(fromP, plainY) to:CGPointMake(toP, plainY) context:context];
    [self drawLineFrom:CGPointMake(fromP, ScreenRect.size.height) to:CGPointMake(toP, ScreenRect.size.height) context:context];
    [self drawLineFrom:CGPointMake(fromP, _F(189)) to:CGPointMake(toP, _F(189)) context:context];
}

- (void)drawLineFrom:(CGPoint)fromP to:(CGPoint)toP context:(CGContextRef)context {
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, fromP.x, fromP.y);
    CGContextAddLineToPoint(context,toP.x, toP.y);
    CGContextStrokePath(context);
}

@end
