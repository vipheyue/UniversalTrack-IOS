//
//  TrackedViewController.m
//  ChildTrack
//
//  Created by zzy on 14/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "TrackedViewController.h"
#import "SGQRCode.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface TrackedViewController ()

@end

@implementation TrackedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"追踪我";
    
    UILabel *tipLbl = [[UILabel alloc]init];
    tipLbl.text = @"使用本软件，扫一扫二维码好友即可追踪你";
    tipLbl.font = [UIFont systemFontOfSize:14];
    tipLbl.textColor = [UIColor darkGrayColor];
    [tipLbl sizeToFit];
    tipLbl.frame = CGRectMake(0, 85, tipLbl.width, tipLbl.height);
    tipLbl.centerX = self.view.centerX;
    [self.view addSubview:tipLbl];
    
    UIImageView *qrCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, tipLbl.bottom+25, 150, 150)];
    qrCodeImageView.centerX = self.view.centerX;
    qrCodeImageView.image = [SGQRCodeGenerateManager SG_generateWithDefaultQRCodeData:[[FCUUID uuidForDevice] substringFromIndex:16] imageViewWidth:qrCodeImageView.width];
    [self.view addSubview:qrCodeImageView];
    
    UILabel *identityLbl = [[UILabel alloc]init];
    identityLbl.textAlignment = NSTextAlignmentCenter;
    identityLbl.text = [NSString stringWithFormat:@"我的身份ID:%@",[[FCUUID uuidForDevice] substringFromIndex:16]];
    identityLbl.font = [UIFont systemFontOfSize:14];
    identityLbl.textColor = [UIColor darkGrayColor];
    [identityLbl sizeToFit];
    identityLbl.frame = CGRectMake(0, qrCodeImageView.bottom+25, ScreenW - 8 - 8, identityLbl.height);
    identityLbl.centerX = self.view.centerX;
    [self.view addSubview:identityLbl];
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.backgroundColor = [UIColor colorWithHexString:@"de88a5"];
    [copyBtn setTitle:@"点击复制身份ID，叫好友来追踪我" forState:UIControlStateNormal];
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    copyBtn.layer.cornerRadius = 10;
    copyBtn.frame = CGRectMake(15, identityLbl.bottom+25, ScreenW - 2*15, 50);
    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyBtn];
}

- (void)copyBtnClick {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"你好";
    
    NSArray *imageArray = @[[UIImage imageNamed:@"checkbox_selected"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
