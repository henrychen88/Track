//
//  FMDBHelper.m
//  Track
//
//  Created by Henry on 15/7/29.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "FMDBHelper.h"

#define     DOCUMENT_PATH       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

const static NSString *tableName = @"person";

@implementation FMDBHelper

/*
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
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'name' TEXT, 'age' TEXT)",tableName];
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

- (BOOL)insertSinleData:(Person *)person
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (name,age) values(?,?)",tableName];
        if ([db executeUpdate:sql,person.name,person.age]) {
            [db close];
            return YES;
        }else{
            [db close];
            return NO;
        }
    }
    return NO;
}

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

- (NSMutableArray *)queryData
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray *lists = [[NSMutableArray alloc]init];
        while ([rs next]) {
            Person *person = [[Person alloc]init];
            
            person.name = [rs stringForColumn:@"name"];
            person.age  = [rs stringForColumn:@"age"];
            
            [lists addObject:person];
        }
        
        [db close];
        return lists;
    }
    return nil;
}

- (BOOL)deleteByName:(NSString *)name
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE name = ?",tableName];
        if ([db executeUpdate:sql,name]) {
            [db close];
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
*/
@end

