//
//  CommUtils.h
//  SwapSpace
//
//  Created by zzy on 04/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommUtils : NSObject

+ (CommUtils *)sharedInstance;
/**
 * 获取是否同意了软件协议的状态
 */
- (BOOL)fetchAgreeSoftState;
/**
 * 保存同意软件协议的状态
 */
- (void)saveAgreeSoftState:(BOOL)isAgree;

@end
