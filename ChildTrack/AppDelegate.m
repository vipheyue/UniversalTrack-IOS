//
//  AppDelegate.m
//  ChildTrack
//
//  Created by zzy on 02/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+RootViewController.h"
#import "MainViewController.h"
#import "SoftAgreementViewController.h"
#import "BaseNavigationController.h"
#import "TrackManage.h"
#import "MapViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//支付宝SDK
#import "APOpenAPI.h"
#import <Bugly/Bugly.h>


@interface AppDelegate ()<BMKGeneralDelegate, UIAlertViewDelegate>

/** 身份ID */
@property (nonatomic, copy) NSString *identityId;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self initSDK];
    
    // 调整SVProgressHUD的背景色和前景色
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    BaseNavigationController *nav;
    
    if ([[CommUtils sharedInstance] fetchAgreeSoftState]) { //如果已经同意了软件协议，直接进入主页
        
        MainViewController *mainVC = [[MainViewController alloc]init];
        nav = [[BaseNavigationController alloc]initWithRootViewController:mainVC];
        
    } else {//否则先进入软件协议界面
        
        SoftAgreementViewController *softAgreeVC = [[SoftAgreementViewController alloc]init];
        nav = [[BaseNavigationController alloc]initWithRootViewController:softAgreeVC];
    }
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initSDK {
    
    // ------ 设置鹰眼SDK的基础信息,每次调用startService开启轨迹服务之前，可以重新设置这些信息。 ------
    BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:TraceAK mcode:TraceMcode serviceID:TraceServiceID keepAlive:YES];
    [[BTKAction sharedInstance] initInfo:sop];
    
    // ------ 初始化地图SDK ------
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    [mapManager start:TraceAK generalDelegate:self];
    
    // ------ Bugly ------
    [Bugly startWithAppId:BuglyAppId];
}

- (void)initShareSDK {

    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformTypeAliSocial)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeAliSocial:
                 [ShareSDKConnector connectAliSocial:[APOpenAPI class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                 
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@""
                                       appSecret:@""];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@""
                                      appKey:@""
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeAliSocial:
                 [appInfo SSDKSetupAliSocialByAppId:@""];
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark - BMKGeneralDelegate
-(void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        
        NSLog(@"授权成功");
        [[TrackManage sharedInstance] StartService];
        
    } else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSString *pasteStr = [UIPasteboard generalPasteboard].string;
    
    if (pasteStr.length == 0) {
        
        return;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\￥(.*?)\\￥"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:pasteStr
                                      options:NSMatchingReportCompletion
                                        range:NSMakeRange(0, [pasteStr length])];

    NSString *matchString = nil;
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        matchString = [pasteStr substringWithRange:matchRange];
        break; // 只处理第一个
    }
    matchString = [matchString stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    if (matchString.length == 0) {
        
        return;
    }
    
    self.identityId = matchString;
    
    NSString *message = [NSString stringWithFormat:@"确定要查询身份ID为：%@的用户轨迹吗？",matchString];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    [UIPasteboard generalPasteboard].string = @""; //清空剪切板
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [[TrackManage sharedInstance] trackWithCompletionBlock:self.identityId trackBlock:^(BMKMapPoint *points, NSMutableArray *poisWithoutZero) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                MapViewController *mapVC = [[MapViewController alloc]initWithParams:poisWithoutZero points:points];
                [[self getTopViewController].navigationController pushViewController:mapVC animated:YES];
            });
            
        }];
    }
}

@end
