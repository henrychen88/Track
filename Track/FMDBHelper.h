//
//  FMDBHelper.h
//  Track
//
//  Created by Henry on 15/7/29.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBHelper : NSObject

- (BOOL)isDataBaseExist;

- (BOOL)createTable;

//- (BOOL)insertSinleData:(Person *)person;

- (BOOL)insertMultiData:(NSArray *)lists;

- (NSMutableArray *)queryData;

- (BOOL)deleteByName:(NSString *)name;

- (BOOL)deleteAll;

- (BOOL)modify:(NSString *)name setAge:(NSString *)age;

@end
