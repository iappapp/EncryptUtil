//
//  StringUtil.m
//  EncryptUtil
//
//  Created by tree on 2018/12/23.
//  Copyright © 2018年 tree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringUtil.h"

@implementation StringUtil

+(NSString*) handleSpaceAndEnterElementWithString:(NSString *) string {
    return [self handleSpaceAndEnterElement: string];
}

+(NSString *)handleSpaceAndEnterElement:(NSString *) string {
    NSString *replaceResult = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    replaceResult = [replaceResult stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    replaceResult = [replaceResult stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    replaceResult = [replaceResult stringByReplacingOccurrencesOfString:@" " withString:@""];
    replaceResult = [replaceResult stringByReplacingOccurrencesOfString:@"(" withString:@""];
    replaceResult = [replaceResult stringByReplacingOccurrencesOfString:@")" withString:@""];
    replaceResult = [replaceResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray *array = [replaceResult componentsSeparatedByString:@","];
    return [array objectAtIndex:0];
}
+(NSString *)replaceUnicode:(NSString *) unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
@end
