//
//  AppDelegate+RootViewController.h
//  ChildTrack
//
//  Created by zhangzey on 23/04/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (RootViewController)

/**
 获取当前显示在最顶层的ViewController
 
 @return return  获取最顶层ViewController
 */
- (UIViewController *)getTopViewController;

@end
