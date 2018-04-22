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

@interface TrackManage()<BTKTrackDelegate,BTKTraceDelegate>

@property(copy,nonatomic)TrackBlock trackBlock;
@property (nonatomic,strong)dispatch_group_t historyDispatchGroup;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, assign) NSUInteger firstResponseSize;
@property (nonatomic, assign) NSUInteger total;
@property(copy, nonatomic)NSString *entityName;
@property(assign, nonatomic)NSUInteger endTime;
/**  标志是否已经开启轨迹服务  */
@property (nonatomic, assign) BOOL isServiceStarted;
/** 标志是否已经开始采集 */
@property (nonatomic, assign) BOOL isGatherStarted;
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

/**
 * 开启轨迹
 */
- (void)StartService {
    
    if (!self.isServiceStarted) {
        
        BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:[[FCUUID uuidForDevice] substringFromIndex:16]];
        // 开启服务
        [[BTKAction sharedInstance] startService:op delegate:self];
    }
}

/**
 * 查询轨迹
 */
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

#pragma mark --- BTKTrackDelegate ---

#pragma mark - BTKTraceDelegate
-(void)onStartService:(BTKServiceErrorCode)error {
    // 维护状态标志
    if (error == BTK_START_SERVICE_SUCCESS || error == BTK_START_SERVICE_SUCCESS_BUT_OFFLINE) {
        NSLog(@"轨迹服务开启成功");
        self.isServiceStarted = YES;
        if (!self.isGatherStarted) {
            [[BTKAction sharedInstance] startGather:self];
        }
    } else {
        NSLog(@"轨迹服务开启失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_START_SERVICE_SUCCESS:
            title = @"轨迹服务开启成功";
            message = @"成功登录到服务端";
            break;
        case BTK_START_SERVICE_SUCCESS_BUT_OFFLINE:
            title = @"轨迹服务开启成功";
            message = @"当前网络不畅，未登录到服务端。网络恢复后SDK会自动重试";
            break;
        case BTK_START_SERVICE_PARAM_ERROR:
            title = @"轨迹服务开启失败";
            message = @"参数错误,点击右上角设置按钮设置参数";
            break;
        case BTK_START_SERVICE_INTERNAL_ERROR:
            title = @"轨迹服务开启失败";
            message = @"SDK服务内部出现错误";
            break;
        case BTK_START_SERVICE_NETWORK_ERROR:
            title = @"轨迹服务开启失败";
            message = @"网络异常";
            break;
        case BTK_START_SERVICE_AUTH_ERROR:
            title = @"轨迹服务开启失败";
            message = @"鉴权失败，请检查AK和MCODE等配置信息";
            break;
        case BTK_START_SERVICE_IN_PROGRESS:
            title = @"轨迹服务开启失败";
            message = @"正在开启服务，请稍后再试";
            break;
        case BTK_SERVICE_ALREADY_STARTED_ERROR:
            title = @"轨迹服务开启失败";
            message = @"已经成功开启服务，请勿重复开启";
            break;
        default:
            title = @"通知";
            message = @"轨迹服务开启结果未知";
            break;
    }
    
}

-(void)onStopService:(BTKServiceErrorCode)error {
    // 维护状态标志
    if (error == BTK_STOP_SERVICE_NO_ERROR) {
        NSLog(@"轨迹服务停止成功");
        self.isServiceStarted = NO;
    } else {
        NSLog(@"轨迹服务停止失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_STOP_SERVICE_NO_ERROR:
            title = @"轨迹服务停止成功";
            message = @"SDK已停止工作";
            break;
        case BTK_STOP_SERVICE_NOT_YET_STARTED_ERROR:
            title = @"轨迹服务停止失败";
            message = @"还没有开启服务，无法停止服务";
            break;
        case BTK_STOP_SERVICE_IN_PROGRESS:
            title = @"轨迹服务停止失败";
            message = @"正在停止服务，请稍后再试";
            break;
        default:
            title = @"通知";
            message = @"轨迹服务停止结果未知";
            break;
    }
    
}

-(void)onStartGather:(BTKGatherErrorCode)error {
    // 维护状态标志
    if (error == BTK_START_GATHER_SUCCESS) {
        NSLog(@"开始采集成功");
        self.isGatherStarted = YES;
    } else {
        NSLog(@"开始采集失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_START_GATHER_SUCCESS:
            title = @"开始采集成功";
            message = @"开始采集成功";
            break;
        case BTK_GATHER_ALREADY_STARTED_ERROR:
            title = @"开始采集失败";
            message = @"已经在采集轨迹，请勿重复开始";
            break;
        case BTK_START_GATHER_BEFORE_START_SERVICE_ERROR:
            title = @"开始采集失败";
            message = @"开始采集必须在开始服务之后调用";
            break;
        case BTK_START_GATHER_LOCATION_SERVICE_OFF_ERROR:
            title = @"开始采集失败";
            message = @"没有开启系统定位服务";
            break;
        case BTK_START_GATHER_LOCATION_ALWAYS_USAGE_AUTH_ERROR:
            title = @"开始采集失败";
            message = @"没有开启后台定位权限";
            break;
        case BTK_START_GATHER_INTERNAL_ERROR:
            title = @"开始采集失败";
            message = @"SDK服务内部出现错误";
            break;
        default:
            title = @"通知";
            message = @"开始采集轨迹的结果未知";
            break;
    }
}

-(void)onStopGather:(BTKGatherErrorCode)error {
    // 维护状态标志
    if (error == BTK_STOP_GATHER_NO_ERROR) {
        NSLog(@"停止采集成功");
        self.isGatherStarted = NO;
    } else {
        NSLog(@"停止采集失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_STOP_GATHER_NO_ERROR:
            title = @"停止采集成功";
            message = @"SDK停止采集本设备的轨迹信息";
            break;
        case BTK_STOP_GATHER_NOT_YET_STARTED_ERROR:
            title = @"开始采集失败";
            message = @"还没有开始采集，无法停止";
            break;
        default:
            title = @"通知";
            message = @"停止采集轨迹的结果未知";
            break;
    }
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
        NSLog(@"%@",message);

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
