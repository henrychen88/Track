//
//  FMDBHelper.m
//  Track
//
//  Created by Henry on 15/7/29.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "FMDBHelper.h"

#import <FMDB/FMDB.h>

#import "Riding.h"

#define     DOCUMENT_PATH       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

const static NSString *tableName = @"riding";

@implementation FMDBHelper

+ (FMDBHelper *)instance
{
    static dispatch_once_t onceToken;
    static FMDBHelper *instance;
    dispatch_once(&onceToken, ^{
        instance = [[FMDBHelper alloc]init];
    });
    return instance;
}


- (BOOL)isDataBaseExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self dbPath]]) {
        NSLog(@"DATABASE IS ALERADY EXIST");
        return YES;
    }
    return NO;
}

- (BOOL)createTable
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'starttime' TEXT, 'alltime' TEXT, 'resttime' TEXT, 'locations' blob)",tableName];
        if ([db executeUpdate:sql]) {
            NSLog(@"CREATE TABLE SUCCESS");
            [db close];
            return YES;
        }else{
            NSLog(@"CREATE TABLE FAILED");
            [db close];
            return NO;
        }
    }else{
        NSLog(@"OPEN DATABASE FAILED WHEN CREATE TBALE");
    }
    return NO;
}

- (BOOL)insertSinleData:(Riding *)riding
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (starttime,alltime,resttime,locations) values(?,?,?,?)",tableName];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:riding.locations];
        if ([db executeUpdate:sql,riding.date ,riding.allTime, riding.restTime, data]) {
            [db close];
            NSLog(@"数据插入成功");
            return YES;
        }else{
            [db close];
            return NO;
        }
    }
    return NO;
}

/*
 - (BOOL)insertMultiData:(NSArray *)lists
 {
 FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
 if ([db open]) {
 [db beginTransaction];
 BOOL isRollBack = NO;
 NSInteger length = [lists count];
 NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (name,age) values(?,?)",tableName];
 @try {
 for (int i = 0; i < length; i++) {
 Person *person = [lists objectAtIndex:i];
 if (![db executeUpdate:sql,person.name,person.age]) {
 NSLog(@"INSERT MULTI DATA FAILED");
 }
 }
 }
 @catch (NSException *exception) {
 isRollBack = YES;
 [db rollback];
 NSLog(@"ROLLBACK WHEN INSERT MULTI DATA");
 }
 @finally {
 if (!isRollBack) {
 [db commit];
 }
 }
 [db close];
 return !isRollBack;
 }
 return NO;
 }
 */

- (NSMutableArray *)queryData
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray *lists = [[NSMutableArray alloc]init];
        while ([rs next]) {
            Riding *riding = [[Riding alloc]init];
            riding.rid = [rs intForColumnIndex:0];
            riding.date = [rs stringForColumn:@"starttime"];
            riding.allTime  = [rs stringForColumn:@"alltime"];
            riding.restTime = [rs stringForColumn:@"alltime"];
            
            NSData *data = [rs dataForColumn:@"locations"];
            riding.locations = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
            [lists addObject:riding];
        }
        
        [db close];
        return lists;
    }
    return nil;
}

- (BOOL)deleteByID:(NSInteger)rid
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ?",tableName];
        if ([db executeUpdate:sql,[NSNumber numberWithInteger:rid]]) {
            [db close];
            NSLog(@"删除成功");
            return YES;
        }else{
            [db close];
        }
    }
    return NO;
}

- (BOOL)deleteAll
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        if ([db executeUpdate:sql]) {
            [db close];
            return YES;
        }else{
            [db close];
        }
    }
    return NO;
}

- (BOOL)modify:(NSString *)name setAge:(NSString *)age
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET age = ? WHERE name = ?",tableName];
        if ([db executeUpdate:sql,age,name]) {
            [db close];
            return YES;
        }else{
            [db close];
        }
    }
    return NO;
    
}

- (NSString *)dbPath
{
    return [DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",tableName]];
}
@end

