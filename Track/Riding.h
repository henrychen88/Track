//
//  Riding.h
//  Track
//
//  Created by 諶俭 on 15/7/29.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  骑行
 */
@interface Riding : NSObject
/**
 *  id
 */
@property(nonatomic, strong) NSString *rid;
/**
 *  骑行开始日期
 */
@property(nonatomic, strong) NSString *date;
/**
 *  骑行总时间
 */
@property(nonatomic, strong) NSString *allTime;
/**
 *  骑行时间
 */
@property(nonatomic, strong) NSString *ridingTime;
/**
 *  休息时间
 */
@property(nonatomic, strong) NSString *restTime;
/**
 *  经过的点
 */
@property(nonatomic, strong) NSArray *locations;
/**
 *  最大速度
 */
@property(nonatomic, strong) NSString *maxSpeed;
/**
 *  最小速度
 */
@property(nonatomic, strong) NSString *minSpeed;
@end
