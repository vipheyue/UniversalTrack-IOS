//
//  MapViewController.m
//  ChildTrack
//
//  Created by zzy on 02/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface MapViewController ()<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"全能追踪";
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    self.view = _mapView;
    [_mapView setZoomLevel:16];
    _mapView.mapType = BMKMapTypeStandard;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
