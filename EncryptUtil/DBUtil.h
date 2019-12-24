//
//  DBUtil.h
//  EncryptUtil
//
//  Created by tree on 2018/12/24.
//  Copyright © 2018年 tree. All rights reserved.
//

#ifndef DBUtil_h
#define DBUtil_h


#endif /* DBUtil_h */
@interface DBUtil : NSObject
-(BOOL) openDBWithName: (NSString*) dbName;
-(BOOL) createTable: (NSString*) sqlString;
-(BOOL) executeSQL:(NSString*) sqlString;
-(BOOL) isTableExist:(NSString*) tableName;
-(BOOL) closeSQLite;
-(void) dealloc;
@end
