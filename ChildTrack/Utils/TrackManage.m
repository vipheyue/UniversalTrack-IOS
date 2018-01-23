//
//  TrackManage.m
//  ChildTrack
//
//  Created by zzy on 21/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "TrackManage.h"

@interface TrackManage()<BTKTrackDelegate>

@property(copy,nonatomic)TrackBlock trackBlock;

@end

@implementation TrackManage

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
    
    NSUInteger endTime = [[NSDate date] timeIntervalSince1970];
    BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:entityName startTime:endTime - 84400 endTime:endTime isProcessed:YES processOption:nil supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_ASC pageIndex:1 pageSize:2000 serviceID:TraceServiceID tag:1];
    [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
    self.trackBlock = trackBlock;
}

- (void)onQueryHistoryTrack:(NSData *)response {
    
    // JSON数据解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSNumber *status = [dic objectForKey:@"status"];
    NSString *message = [dic objectForKey:@"message"];
    
    if ([status longValue] == 0) {
        NSArray *pois = [dic objectForKey:@"points"];
        
        if (pois.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无记录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
            return;
        }
        NSMutableArray *poisWithoutZero = [NSMutableArray array];
        // 去除经纬度为(0,0)的点 将剩余的轨迹点存储在poisWithoutZero中
        for (int i = 0; i < pois.count; i++) {
            NSDictionary *point = [pois objectAtIndex:i];
            NSNumber *longitude = point[@"longitude"];
            NSNumber *latitude = point[@"latitude"];
            if (fabs(longitude.doubleValue - 0) < 0.001 && fabs(latitude.doubleValue - 0) < 0.001) {
                continue;
            }
            [poisWithoutZero addObject:point];
        }
        
        BMKMapPoint *points = malloc(sizeof(BMKMapPoint) * poisWithoutZero.count);
        // 手动分配内存存储轨迹点，并获取最小经度minLon、最大经度maxLon、最小纬度minLat、最大纬度maxLat
        CLLocationCoordinate2D *locations = malloc([poisWithoutZero count] * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < poisWithoutZero.count; i++) {
            
            NSDictionary *point = [poisWithoutZero objectAtIndex:i];
            NSNumber *longitude = point[@"longitude"];
            NSNumber *latitude = point[@"latitude"];
            points[i] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue));
        }
        
        self.trackBlock(points, poisWithoutZero);
        free(locations);
        
    } else if ([status longValue] == 3003) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无记录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"查询失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        NSLog(@"%@", message);
    }
}

@end
