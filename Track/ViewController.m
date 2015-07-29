//
//  ViewController.m
//  Track
//
//  Created by Henry on 15/7/28.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "ViewController.h"

#import <MAMapKit/MAMapKit.h>

@interface ViewController ()<MAMapViewDelegate>
@property(nonatomic, strong) MAMapView *mapView;
@property(nonatomic, getter = isInitalized) BOOL initialized;
@property(nonatomic, strong) NSMutableArray *locations;
@property(nonatomic, strong) MAUserLocation *previousLocation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [MAMapServices sharedServices].apiKey = @"d77f1710195d527b202dd4ea92653b88";
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showTraffic = NO;
    [self.view addSubview:_mapView];
    
    self.locations = [NSMutableArray new];
    
    //程序将要退出的时候，保存当前记录的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate) name:@"applicationWillTerminate" object:nil];
}

- (void)appWillTerminate
{
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    _mapView.showsUserLocation = YES;
    
    [self addLines];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        
        if (!self.isInitalized) {
            [self.mapView setZoomLevel:17 animated:YES];
            self.initialized = YES;
        }
        
        if ([self shoulAddCurrentLocation:userLocation]) {
            NSDictionary *dict = @{@"lat" : [NSNumber numberWithDouble:userLocation.coordinate.latitude] , @"long" : [NSNumber numberWithDouble:userLocation.coordinate.longitude]};
            [self.locations addObject:dict];
            if (self.locations.count == 1000) {
                self.mapView.showsUserLocation = NO;
                
                [[NSUserDefaults standardUserDefaults] setObject:self.locations forKey:@"locations"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
        }
        self.previousLocation = userLocation;
    }
}

- (BOOL)shoulAddCurrentLocation:(MAUserLocation *)currentLocation
{
    if (!self.previousLocation) {
        return YES;
    }else{
        CLLocationDegrees preLat = self.previousLocation.coordinate.latitude;
        CLLocationDegrees preLong = self.previousLocation.coordinate.longitude;
        
        CLLocationDegrees currentLat = currentLocation.coordinate.latitude;
        CLLocationDegrees currentLong = currentLocation.coordinate.longitude;
        
        if ((fabs(currentLat - preLat) > 0.00001) || ((fabs(currentLong - preLong)) > 0.00001)) {
            return YES;
        }
    }
    return NO;
}

- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView
{
    NSLog(@"end end");
}

- (void)addLines
{
    
    NSArray *array = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"locations"];
    if (array.count <= 1) {
        return;
    }else{
        NSLog(@"array %@", array);
    }
    
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

- (void)showCurrentLocation
{
//    MATileOverlay 
}

@end
