//
//  CommUtils.m
//  SwapSpace
//
//  Created by zzy on 04/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "CommUtils.h"
#import "FileNameDefines.h"

@implementation CommUtils
+ (CommUtils *)sharedInstance {
    static dispatch_once_t pred;
    static CommUtils *instance = nil;
    dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    return instance;
}

/**
 * 获取是否同意了软件协议的状态
 */
- (BOOL)fetchAgreeSoftState {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting boolForKey:@"SoftAgreement"];
}

/**
 * 保存同意软件协议的状态
 */
- (void)saveAgreeSoftState:(BOOL)isAgree {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:@(isAgree) forKey:@"SoftAgreement"];
    [setting synchronize];
}

- (NSMutableArray *)getSearchHistoryCache {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:SearchHistoryFileName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
