//
//  MapViewController.m
//  ChildTrack
//
//  Created by zzy on 02/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    BMKPointAnnotation *_pointAnnotation;
}

@property(nonatomic,strong)NSMutableArray *poisWithoutZero;
@property(nonatomic,assign)BMKMapPoint *points;

@end

@implementation MapViewController

- (instancetype)initWithParams:(NSMutableArray *)poisWithoutZero points:(BMKMapPoint *)points
{
    self = [super init];
    if (self) {
        
        
        self.poisWithoutZero = poisWithoutZero;
        self.points = points;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"全能追踪";
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    self.view = _mapView;
    [_mapView setZoomLevel:16];
    _mapView.mapType = BMKMapTypeStandard;
    [self paintingTrack];
    [self addPointAnnotation];
}

- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)paintingTrack {
    
    // 根据轨迹点生成轨迹线
    BMKPolyline *polyline = [BMKPolyline polylineWithPoints:self.points count:[self.poisWithoutZero count]];
    
    if (self.poisWithoutZero.count > 1) {
        // 设定当前地图的显示范围
        //        [_mapView setRegion:viewRegion animated:YES];
        // 向地图窗口添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法来生成标注对应的View
        [_mapView addOverlay:polyline];
    } else {
        NSLog(@"指定轨迹的轨迹点少于两个，无法绘制轨迹");
    }
}

// BMKMapViewDelegate协议中添加轨迹线时调用该方法，根据overlay生成对应的View
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1]; //线的描边颜色
        polylineView.lineWidth = 2.0; //线宽
        return polylineView;
    }
    return nil;
}


//添加当前位置的标注
-(void)addPointAnnotation {
    
    if (nil == _pointAnnotation) {
        _pointAnnotation = [[BMKPointAnnotation alloc] init];
    }
    
    if (self.poisWithoutZero.count > 0) {
        NSDictionary *dict = self.poisWithoutZero[0];
        CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake([dict[@"latitude"] doubleValue], [dict[@"longitude"] doubleValue]);
        _pointAnnotation.coordinate = coord1;
    }
    _pointAnnotation.title = @"起点";
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.poisWithoutZero.count > 0) {
            NSDictionary *dict = self.poisWithoutZero[0];
            CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake([dict[@"latitude"] doubleValue], [dict[@"longitude"] doubleValue]);
            [_mapView setCenterCoordinate:coord1 animated:true];
        }
        
        [_mapView addAnnotation:_pointAnnotation];
    });
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (annotation == _pointAnnotation) {
        NSString *AnnotationViewID = @"myAnnotation";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            //            annotationView.draggable = YES;
        }
        return annotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
