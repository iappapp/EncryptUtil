//
//  SQLiteManager.m
//  EncryptUtil
//
//  Created by tree on 2018/12/24.
//  Copyright © 2018年 tree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteManager.h"
@implementation SQLiteManager
//单例对象
static SQLiteManager* instance;

+(instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
@end
