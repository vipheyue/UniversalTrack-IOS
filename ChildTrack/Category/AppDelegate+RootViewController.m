//
//  AppDelegate+RootViewController.m
//  ChildTrack
//
//  Created by zhangzey on 23/04/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "AppDelegate+RootViewController.h"

@implementation AppDelegate (RootViewController)

- (UIViewController *)getTopViewController {
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getTopViewControllerFromVC:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getTopViewControllerFromVC:(UIViewController *)rootVC {
    
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {// 视图是被presented出来的

        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) { // 根视图为UITabBarController

        currentVC = [self getTopViewControllerFromVC:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {// 根视图为UINavigationController

        currentVC = [self getTopViewControllerFromVC:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {// 根视图为非导航类

        currentVC = rootVC;
    }
    
    return currentVC;

}

@end
