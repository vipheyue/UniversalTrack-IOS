//
//  TrackManage.h
//  ChildTrack
//
//  Created by zzy on 21/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TrackBlock)(BMKMapPoint *points, NSMutableArray *poisWithoutZero);

@interface TrackManage : NSObject

+ (instancetype)sharedInstance;
- (void)trackWithCompletionBlock:(NSString *)entityName trackBlock:(TrackBlock)trackBlock;

@end
