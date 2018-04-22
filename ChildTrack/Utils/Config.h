//
//  Config.h
//  BathroomShopping
//
//  Created by zzy on 7/2/16.
//  Copyright © 2016 zzy. All rights reserved.
//
#ifndef Config_h
#define Config_h

//日志
#ifdef DEBUG

#define NSLog(fmt, ...) NSLog((@"%s:%d " fmt), [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, ##__VA_ARGS__);

#else

#define NSLog(...)

#endif

#define GLOBAL_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define MAIN_QUEUE dispatch_get_main_queue()

//引用
#define WEAKSELF __weak __typeof(self)weakSelf = self;
#define STRONGSELF __strong __typeof(weakSelf)strongSelf = weakSelf;

#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BSNotificationCenter [NSNotificationCenter defaultCenter]
#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define randomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
#define CustomColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha: 1.0]
#define NavgationBarColor [UIColor colorWithHexString:@"#2dbaa6"]
#define kSeparatorLineColor [UIColor colorWithHexString:@"#ebebeb"]

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define kIsIPhoneX ((ScreenW == 375) && (ScreenH == 812))
#define kIPhoneXBottomAddtion (kIsIPhoneX ? 34 : 0)
#define kStatusBarHeight (kIsIPhoneX ? 44.0f : 20.0f)
#define kNavigationBarHeight 44.0f
#define kNavigationPlusStatusHeight (kStatusBarHeight + kNavigationBarHeight)

// ***** SDK参数 *****
#define BuglyAppId @"5b30645c34"
#define TraceAK @"hpnQsDyUx5H1Mksoh2CjGgA0BXYgZhhu"
#define TraceMcode @"com.welightworld.track"
#define TraceServiceID 158728

#endif /* Config_h */



