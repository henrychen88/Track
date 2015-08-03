//
//  ViewController.m
//  Track
//
//  Created by Henry on 15/7/28.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "Riding.h"
#import "FMDBHelper.h"
#import "RecordViewController.h"

#define width   [UIScreen mainScreen].bounds.size.width
#define height  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<MAMapViewDelegate>
@property(nonatomic, strong) MAMapView *mapView;
@property(nonatomic, getter = isStated) BOOL started;
@property(nonatomic, strong) NSMutableArray *locations;
@property(nonatomic, strong) MAUserLocation *previousLocation;
@property(nonatomic, strong) UIButton *startButton;
@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, assign) NSInteger allTime, restTime;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"骑行控";
    [self.rightButton setTitle:@"历史" forState:UIControlStateNormal];

    //地图
    [MAMapServices sharedServices].apiKey = @"d77f1710195d527b202dd4ea92653b88";
    _mapView = [[MAMapView alloc]initWithFrame:self.contentView.bounds];
    _mapView.delegate = self;
    _mapView.showTraffic = NO;
    [self.contentView addSubview:_mapView];
    
    //开始按钮
    CGFloat buttonSize = 100;
    self.startButton = [[UIButton alloc]initWithFrame:CGRectMake((width - buttonSize) / 2.0f, CGRectGetHeight(self.contentView.frame) - buttonSize - 50, buttonSize, buttonSize)];
    self.startButton.layer.masksToBounds = YES;
    self.startButton.layer.cornerRadius= buttonSize / 2.0f;
    self.startButton.backgroundColor = [UIColor greenColor];
    [self.startButton.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
    [self.startButton setTitle:@"开始" forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startButtonAct) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.startButton];
    
    //初始化
    self.locations = [NSMutableArray new];
    if (![[FMDBHelper instance] isDataBaseExist]) {
        [[FMDBHelper instance] createTable];
    }
    
//    [[FMDBHelper instance] deleteByID:1];
//    [[FMDBHelper instance] deleteByID:2];
    
    //程序将要退出的时候，如果正在记录当前的路径则保存当前记录的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate) name:@"applicationWillTerminate" object:nil];
}

- (void)insertRiding
{
    Riding *riding = [Riding new];
    riding.date = self.startTime;
    riding.allTime = [NSString stringWithFormat:@"%ld", (long)self.allTime];
    riding.restTime = [NSString stringWithFormat:@"%ld", (long)self.restTime];
    riding.locations = self.locations;
    [[FMDBHelper instance] insertSinleData:riding];
}

- (void)startButtonAct
{
    if (!self.isStated) {
        self.startTime = [self currentTime];
        self.allTime = 0;
        self.restTime = 0;
        self.started = YES;
        [self.locations removeAllObjects];
    }else{
        [self endTracking];
    }
}

- (void)setStarted:(BOOL)started
{
    _started = started;
    [self.startButton setTitle:(started ? @"结束" : @"开始") forState:UIControlStateNormal];
    [self.startButton setBackgroundColor:(started ? [UIColor redColor] : [UIColor greenColor])];
}

- (NSString *)currentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyy-MM-dd HH:mm";
    return [formatter stringFromDate:[NSDate date]];
}

- (void)appWillTerminate
{
    if (self.isStated) {
        [self endTracking];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _mapView.showsUserLocation = YES;
    
//    [self addLines];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        
        [self.mapView setZoomLevel:17 animated:YES];
        
        if (!self.isStated) {
            return;
        }
        
        
        self.allTime++;
        
        if (YES) {
            NSDictionary *dict = @{
                                   @"lat" : [NSNumber numberWithDouble:userLocation.coordinate.latitude] ,
                                   @"long" : [NSNumber numberWithDouble:userLocation.coordinate.longitude],
                                   @"timestamp" : [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]]
                                   };
            [self.locations addObject:dict];
            self.previousLocation = userLocation;
        }
    }
}

- (void)endTracking
{
    self.started = NO;
    
    if (self.allTime < 10 || self.locations.count < 5) {
        //记录数据太少丢弃这次数据
        return;
    }
    
    Riding *riding = [[Riding alloc]init];
    riding.date = self.startTime;
    riding.allTime = [NSString stringWithFormat:@"%ld", (long)self.allTime];
    riding.restTime = [NSString stringWithFormat:@"%ld", (long)self.restTime];
    riding.locations = self.locations;
    
    [[FMDBHelper instance] insertSinleData:riding];
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
        
        if ((fabs(currentLat - preLat) > 0.000015) || ((fabs(currentLong - preLong)) > 0.000015)) {
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
//        NSLog(@"array %@", array);
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

- (void)rightButtonAction:(UIButton *)button
{
    RecordViewController *viewController = [[RecordViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
