//
//  AppDelegate.m
//  ChildTrack
//
//  Created by zzy on 02/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SoftAgreementViewController.h"
#import "BaseNavigationController.h"
#import <BaiduTraceSDK/BaiduTraceSDK.h>
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface AppDelegate ()<BMKGeneralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self initSDK];
    SoftAgreementViewController *softAgreeVC = [[SoftAgreementViewController alloc]init];

    MainViewController *mainVC = [[MainViewController alloc]init];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:softAgreeVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initSDK {
    
    // 设置鹰眼SDK的基础信息
    // 每次调用startService开启轨迹服务之前，可以重新设置这些信息。
    BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:TraceAK mcode:TraceMcode serviceID:TraceServiceID keepAlive:YES];
    [[BTKAction sharedInstance] initInfo:sop];
    
    // 初始化地图SDK
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    [mapManager start:TraceAK generalDelegate:self];
}

#pragma mark - BMKGeneralDelegate
-(void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        DLog(@"联网成功");
    } else{
        DLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        DLog(@"授权成功");
    } else {
        DLog(@"onGetPermissionState %d",iError);
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
