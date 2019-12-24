//
//  DBUtil.m
//  EncryptUtil
//
//  Created by tree on 2018/12/24.
//  Copyright © 2018年 tree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBUtil.h"
#import "sqlite3.h"

@implementation DBUtil
{
@private sqlite3* db;
}
- (BOOL)openDBWithName:(NSString *)dbName {
    // TODO 使用全局变量
    NSString* documentPath = @"/Users/tree";
    NSString* path = [documentPath stringByAppendingString: @"/db.sqlite"];
    if (sqlite3_open(path.UTF8String, &db) != SQLITE_OK) {
        NSLog(@"open SQLite error");
        return NO;
    }
    NSLog(@"open SQLite success");
    return YES;
}

- (BOOL)executeSQL:(NSString *)sqlString {
    char* errorMessage = NULL;
    if (sqlite3_exec(db, [sqlString UTF8String], NULL, NULL, &errorMessage) == SQLITE_OK) {
        NSLog(@"executSQL=%@", sqlString);
        return YES;
    }
    NSLog(@"executeSQL=%@ error", sqlString);
    return NO;
}

- (BOOL)createTable:(NSString *) sqlString {
    return [self executeSQL: sqlString];
}

- (BOOL)isTableExist:(NSString*) tableName {
    NSString* sql = [NSString stringWithFormat:@"select count(*) count from sqlite_master where type=\"table\" and name=\"%@\"", tableName];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    array = [self queryBySQL: sql];
    NSMutableDictionary* dic = [array objectAtIndex:0];
    if ((int)[dic valueForKey:@"count"] == 1) {
        NSLog(@"table=%@ is exist", tableName);
        return YES;
    }
    NSLog(@"table=%@ is not exist", tableName);
    return NO;
}

- (NSMutableArray*) queryBySQL:(NSString *) sql {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        // int num_cols = sqlite3_data_count(stmt);
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            int num_cols = sqlite3_column_count(stmt);
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_cols];
            if (num_cols > 0) {
                int i;
                for (i = 0; i < num_cols; i++) {
                    const char *col_name = sqlite3_column_name(stmt, i);
                    if (col_name) {
                        NSString *colName = [NSString stringWithUTF8String:col_name];
                        id value = nil;
                        // fetch according to type
                        switch (sqlite3_column_type(stmt, i)) {
                            case SQLITE_INTEGER: {
                                int i_value = sqlite3_column_int(stmt, i);
                                value = [NSNumber numberWithInt:i_value];
                                break;
                            }
                            case SQLITE_FLOAT: {
                                double d_value = sqlite3_column_double(stmt, i);
                                value = [NSNumber numberWithDouble:d_value];
                                break;
                            }
                            case SQLITE_TEXT: {
                                char *c_value = (char *)sqlite3_column_text(stmt, i);
                                value = [[NSString alloc] initWithUTF8String:c_value];
                                break;
                            }
                            case SQLITE_BLOB: {
                                value = (__bridge id)(sqlite3_column_blob(stmt, i));
                                break;
                            }
                        }
                        // save to dict
                        if (value) {
                            [dict setObject:value forKey:colName];
                        }
                    }
                }
            }
            [result addObject:dict];
        }
        sqlite3_finalize(stmt);
    }
    return result;
}

- (BOOL) closeSQLite {
    if(sqlite3_close(db) == SQLITE_OK){
        NSLog(@"closeSQLite sucess");
        return YES;
    }
    NSLog(@"closeSQLite fail");
    return NO;
}

- (void) dealloc {
    [self closeSQLite];
    db = NULL;
}

@end
