//
//  RecordDetailViewController.m
//  Track
//
//  Created by 諶俭 on 15/8/1.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "RecordDetailViewController.h"

#import <MAMapKit/MAMapKit.h>

@interface RecordDetailViewController ()<MAMapViewDelegate>
@property(nonatomic, strong) MAMapView *mapView;
@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    
    _mapView = [[MAMapView alloc]initWithFrame:self.contentView.bounds];
    _mapView.delegate = self;
    [self.contentView addSubview:_mapView];
    
    [self addLines];
    
    [self zoomToMapPoints:self.mapView annotations:self.riding.locations];
}

- (void)leftButtonAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 骑行路径

- (void)addLines
{
    NSArray *array = self.riding.locations;
 
     NSInteger count = array.count;
     
     CLLocationCoordinate2D commonPolylineCoords[count];
     
     for (NSInteger i = 0; i < count; i++) {
     NSDictionary *dict = array[i];
     commonPolylineCoords[i].latitude = [dict[@"lat"] doubleValue];
     commonPolylineCoords[i].longitude = [dict[@"long"] doubleValue];
     }
     
     MAPolyline *lines = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count];
     
     [self.mapView addOverlay:lines];
}
 
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
 if ([overlay isKindOfClass:[MAPolyline class]]) {
 MAPolylineView * polylineView = [[MAPolylineView alloc]initWithPolyline:overlay];
 
 polylineView.lineWidth = 7.f;
 polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
 polylineView.lineJoinType = kMALineJoinRound;
 polylineView.lineCapType = kMALineCapRound;
 return polylineView;
 }
 return nil;
}


- (void)zoomToMapPoints:(MAMapView*)mapView annotations:(NSArray*)annotations
{
    double minLat = 360.0f, maxLat = -360.0f;
    double minLon = 360.0f, maxLon = -360.0f;
    for (NSDictionary *annotation in annotations) {
        double lat = [annotation[@"lat"] doubleValue];
        double longti = [annotation[@"long"] doubleValue];
        if ( lat  < minLat ) minLat = lat;
        if ( lat  > maxLat ) maxLat = lat;
        if ( longti < minLon ) minLon = longti;
        if ( longti > maxLon ) maxLon = longti;
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) / 2.0, (minLon + maxLon) / 2.0);
    MACoordinateSpan span = MACoordinateSpanMake((maxLat - minLat) * 1.15, (maxLon - minLon) * 1.15);
//    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
    MACoordinateRegion region = MACoordinateRegionMake(center, span);
//    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [mapView setRegion:region animated:YES];
}

@end
