//
//  TrackManage.m
//  ChildTrack
//
//  Created by zzy on 21/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "TrackManage.h"

// 轨迹查询每页的上限为5000条，但是若请求纠偏甚至绑路后的轨迹，比较耗时。综合考虑，我们选取每页1000条
static NSUInteger const kHistoryTrackPageSize = 1000;

@interface TrackManage()<BTKTrackDelegate>

@property(copy,nonatomic)TrackBlock trackBlock;
@property (nonatomic,strong)dispatch_group_t historyDispatchGroup;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, assign) NSUInteger firstResponseSize;
@property (nonatomic, assign) NSUInteger total;
@property(copy, nonatomic)NSString *entityName;
@property(assign, nonatomic)NSUInteger endTime;

@end

@implementation TrackManage

- (dispatch_group_t)historyDispatchGroup {
    
    if (_historyDispatchGroup == nil) {
        
        _historyDispatchGroup = dispatch_group_create();
    }
    
    return _historyDispatchGroup;
}

+ (instancetype)sharedInstance
{
    static TrackManage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TrackManage alloc] init];
    });
    return sharedInstance;
}

- (void)trackWithCompletionBlock:(NSString *)entityName trackBlock:(TrackBlock)trackBlock {
    
    self.entityName = entityName;
    self.endTime = [[NSDate date] timeIntervalSince1970];
    // 发送第一次请求，确定size和total，以决定后续是否还需要发请求，以及发送请求的pageSize和pageIndex
    dispatch_async(GLOBAL_QUEUE, ^{
        BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:entityName startTime:self.endTime - 84400 endTime:self.endTime isProcessed:YES processOption:nil supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_ASC pageIndex:1 pageSize:kHistoryTrackPageSize serviceID:TraceServiceID tag:1];
        [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
    });
    self.trackBlock = trackBlock;
}

- (void)onQueryHistoryTrack:(NSData *)response {
    
    // JSON数据解析
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    if (dict == nil) {

        dispatch_async(MAIN_QUEUE, ^{
            
            [SVProgressHUD showErrorWithStatus:@"查询失败！"];
        });

    } else {

        NSNumber *status = [dict objectForKey:@"status"];
        NSString *message = [dict objectForKey:@"message"];
        DLog(@"%@",message);

        if ([status intValue] != 0) {
            
            if ([status intValue] == 3003) {
                
                dispatch_async(MAIN_QUEUE, ^{
                    
                    [SVProgressHUD showImage:nil status:@"暂无记录！"];
                });
                
            } else {
                
                dispatch_async(MAIN_QUEUE, ^{
                    
                    [SVProgressHUD showErrorWithStatus:@"查询失败！"];
                });
                
            }
            
        } else {
            
            if ([dict[@"tag"] unsignedIntValue] == 1) {
                
                NSArray *pois = [dict objectForKey:@"points"];
                // 去除经纬度为(0,0)的点 将剩余的轨迹点存储在poisWithoutZero中
                for (int i = 0; i < pois.count; i++) {
                    NSDictionary *point = [pois objectAtIndex:i];
                    NSNumber *longitude = point[@"longitude"];
                    NSNumber *latitude = point[@"latitude"];
                    if (fabs(longitude.doubleValue - 0) < 0.001 && fabs(latitude.doubleValue - 0) < 0.001) {
                        continue;
                    }
                    [self.points addObject:point];
                }
                
                // 对于第一次回调结果，根据total和size，确认还需要发送几次请求，并行发送这些请求
                // 使用dispatch_group同步多次请求，当所有请求均收到响应后，points属性中存储的就是所有的轨迹点了
                // 根据请求的是否是纠偏后的结果，处理方式稍有不同：
                // 若是纠偏后的轨迹，直接使用direction字段即可，该方向是准确的；
                // 若是原始的轨迹，direction字段可能不准，我们自己根据相邻点计算出方向。
                // 最好都是请求纠偏后的轨迹，简化客户端处理步骤
                self.firstResponseSize = [dict[@"size"] unsignedIntValue];
                self.total = [dict[@"total"] unsignedIntValue];
                if (self.total == 0 && self.firstResponseSize == 0) {
                    
                    dispatch_async(MAIN_QUEUE, ^{
                        
                        [SVProgressHUD showImage:nil status:@"暂无记录！"];
                    });
                    return;
                }
                for (size_t i = 0; i < self.total / self.firstResponseSize; i++) {
                    dispatch_group_enter(self.historyDispatchGroup);
                    BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:self.entityName startTime:self.endTime - 84400 endTime:self.endTime isProcessed:YES processOption:nil supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_ASC pageIndex:(2 + i) pageSize:kHistoryTrackPageSize serviceID:TraceServiceID tag:(2 + i)];
                    [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
                }
                dispatch_group_notify(self.historyDispatchGroup, GLOBAL_QUEUE, ^{
                    // 将所有查询到的轨迹点，按照loc_time升序排列，注意是稳定排序。
                    // 因为绑路时会补充道路形状点，其loc_time与原始轨迹点一样，相同的loc_time在排序后必须保持原始的顺序，否则direction不准。
                    [self.points sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(NSDictionary *  _Nonnull obj1, NSDictionary *  _Nonnull obj2) {
                        if ([obj1[@"loc_time"] unsignedIntValue] < [obj2[@"loc_time"] unsignedIntValue]) {
                            return NSOrderedAscending;
                        } else if ([obj1[@"loc_time"] unsignedIntValue] > [obj2[@"loc_time"] unsignedIntValue]) {
                            return NSOrderedDescending;
                        } else {
                            return NSOrderedSame;
                        }
                    }];
                    
                    BMKMapPoint *points = malloc(sizeof(BMKMapPoint) * self.points.count);
                    // 手动分配内存存储轨迹点，并获取最小经度minLon、最大经度maxLon、最小纬度minLat、最大纬度maxLat
                    CLLocationCoordinate2D *locations = malloc([self.points count] * sizeof(CLLocationCoordinate2D));
                    for (int i = 0; i < self.points.count; i++) {
                        
                        NSDictionary *point = [self.points objectAtIndex:i];
                        NSNumber *longitude = point[@"longitude"];
                        NSNumber *latitude = point[@"latitude"];
                        points[i] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue));
                    }
                    
                    self.trackBlock(points, self.points);
                    free(locations);
                });
                
            } else {
                
                dispatch_group_leave(self.historyDispatchGroup);
            }
        }

    }
}

@end
